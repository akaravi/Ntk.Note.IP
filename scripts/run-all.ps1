param(
    [switch]$SkipBuild,
    [switch]$SkipFlutter,
    [switch]$UseRedisContainer,
    [switch]$Restart,
    [switch]$SkipHealth,
    [switch]$CheckSsl,
    [string]$WebBaseUrl = '',
    [int]$StartupWaitSeconds = 90
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
. "$PSScriptRoot\local-dev-ports.ps1"
Set-Location $root

function Stop-IpNoteDevProcesses {
    Write-Host 'Stopping prior IPNote dev processes...' -ForegroundColor Yellow
    Get-Process -Name 'dotnet', 'Ntk.Note.IP.Web', 'Ntk.Note.IP.AppHost' -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -like '*Ntk.Note.IP*' } |
        Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

Write-Host '=== IPNote.ir run-all ===' -ForegroundColor Cyan

if ($Restart) {
    Stop-IpNoteDevProcesses
}

if (-not $SkipBuild) {
    Write-Host '[1/7] Debug build + tests...' -ForegroundColor Cyan
    & "$root\build.ps1"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
else {
    Write-Host '[1/7] SKIP build (-SkipBuild)' -ForegroundColor DarkGray
}

if (-not $SkipFlutter) {
    Write-Host '[2/7] Flutter analyze + test...' -ForegroundColor Cyan
    & "$root\scripts\flutter-ci.ps1" -SkipPubGet
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
else {
    Write-Host '[2/7] SKIP Flutter (-SkipFlutter)' -ForegroundColor DarkGray
}

Write-Host '[3/7] Angular SPA -> wwwroot...' -ForegroundColor Cyan
& "$root\scripts\build-spa-to-wwwroot.ps1"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$logDir = Join-Path $root 'artifacts\logs'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$logFile = Join-Path $logDir ("apphost-{0:yyyyMMdd-HHmmss}.log" -f (Get-Date))

if ($UseRedisContainer) {
    $env:IPNOTE_USE_REDIS_CONTAINER = 'true'
}
else {
    Remove-Item Env:IPNOTE_USE_REDIS_CONTAINER -ErrorAction SilentlyContinue
}

$env:ASPIRE_ALLOW_UNSECURED_TRANSPORT = 'true'
$env:DOTNET_ENVIRONMENT = 'Development'

Write-Host "[4/7] Starting Aspire AppHost (background, log: $logFile)..." -ForegroundColor Cyan
$appHostProject = Join-Path $root 'src\AppHost\AppHost.csproj'
$runArgs = @('run', '--project', $appHostProject, '--launch-profile', 'http')
if (-not $SkipBuild) {
    $runArgs += '--no-build'
}

$logErr = "$logFile.err"
$proc = Start-Process -FilePath 'dotnet' -ArgumentList $runArgs -WorkingDirectory $root -PassThru `
    -RedirectStandardOutput $logFile -RedirectStandardError $logErr -WindowStyle Hidden

Write-Host "  PID: $($proc.Id)" -ForegroundColor DarkGray

if (-not $SkipHealth) {
    Write-Host '[5/7] Discovering Web API URL + health checks...' -ForegroundColor Cyan

    if ([string]::IsNullOrWhiteSpace($WebBaseUrl)) {
        $discovered = & "$root\scripts\discover-web-base-url.ps1" -LogPath $logFile -TimeoutSeconds $StartupWaitSeconds 2>$null
        if ($LASTEXITCODE -ne 0) {
            & "$root\scripts\scan-run-log.ps1" -LogPath $logFile
            if ($proc -and -not $proc.HasExited) { Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue }
            exit 1
        }
        $WebBaseUrl = "$discovered".Trim()
    }

    $WebBaseUrl = $WebBaseUrl.Trim().TrimEnd('/')
    Write-Host "  Using WebBaseUrl: $WebBaseUrl" -ForegroundColor DarkGray

    & "$root\scripts\verify-health.ps1" -WebBaseUrl $WebBaseUrl -WaitSeconds 15
    if ($LASTEXITCODE -ne 0) {
        & "$root\scripts\scan-run-log.ps1" -LogPath $logFile
        exit $LASTEXITCODE
    }

    & "$root\scripts\post-deploy-smoke.ps1" -WebBaseUrl $WebBaseUrl -WaitSeconds 5 -SkipK6
    if ($LASTEXITCODE -ne 0) {
        & "$root\scripts\scan-run-log.ps1" -LogPath $logFile
        exit $LASTEXITCODE
    }
}
else {
    Write-Host '[5/7] SKIP health (-SkipHealth)' -ForegroundColor DarkGray
    if ([string]::IsNullOrWhiteSpace($WebBaseUrl)) {
        $WebBaseUrl = Get-IpNoteWebBaseUrl
    }
}

if ($CheckSsl) {
    Write-Host '[6/7] TLS probe (https://localhost:5341/health)...' -ForegroundColor Cyan
    $tlsUrl = "$(Get-IpNoteWebHttpsUrl)/health"
    try {
        $tlsParams = @{
            Uri             = $tlsUrl
            UseBasicParsing = $true
            TimeoutSec      = 10
        }
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            $tlsParams['SkipCertificateCheck'] = $true
        }
        $tls = Invoke-WebRequest @tlsParams
        if ($tls.StatusCode -eq 200) {
            Write-Host "OK  [ssl] $tlsUrl -> 200 (dev cert; use -SkipCertificateCheck on PS 7+)" -ForegroundColor Green
        }
        else {
            Write-Host "WARN [ssl] $tlsUrl -> $($tls.StatusCode)" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "WARN [ssl] $tlsUrl not reachable ($($_.Exception.Message)). Run Web with https profile or trust dev cert." -ForegroundColor Yellow
    }
}
else {
    Write-Host '[6/7] SKIP TLS (-CheckSsl; use -CheckSsl to probe https://localhost:5341)' -ForegroundColor DarkGray
}

Write-Host '[7/7] Log scan...' -ForegroundColor Cyan
if (Test-Path -LiteralPath $logErr) {
    Get-Content -LiteralPath $logErr -ErrorAction SilentlyContinue | Add-Content -LiteralPath $logFile
}
& "$root\scripts\scan-run-log.ps1" -LogPath $logFile

Write-Host ''
Write-Host '=== Service URLs ===' -ForegroundColor Cyan
@(
    "Aspire dashboard:  $(Get-IpNoteAspireDashboardUrl)",
    "Web API (health):  $WebBaseUrl/health",
    "Scalar OpenAPI:    $WebBaseUrl/scalar",
    "Status page:       $WebBaseUrl/status.html",
    "Changelog:         $WebBaseUrl/changelog.html",
    "App Links:         $WebBaseUrl/.well-known/assetlinks.json",
    "Hangfire (dev):    $WebBaseUrl/hangfire",
    "Angular SPA:       same origin as Web",
    "AppHost log:       $logFile",
    "AppHost log (err): $logErr"
) | ForEach-Object { Write-Host "  $_" }

Write-Host ''
Write-Host 'Flutter emulator:' -ForegroundColor DarkGray
Write-Host "  cd src\Mobile\ntk_note_ip_app && flutter run --dart-define=API_BASE_URL=$(Get-IpNoteFlutterEmulatorApiUrl)" -ForegroundColor DarkGray
Write-Host ''
Write-Host 'Stop AppHost: .\scripts\restart-all.ps1 -Restart (or kill dotnet PID above)' -ForegroundColor DarkGray
Write-Host 'Run-all completed. AppHost is still running in background.' -ForegroundColor Green
