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

$script:RunResults = [System.Collections.Generic.List[object]]::new()
$script:ExitCode = 0
$script:WebBaseUrlFinal = ''
$script:AppHostPid = 0
$script:LogFile = ''
$script:LogErr = ''
$script:OverallStatus = 'OK'

function Add-RunResult {
    param(
        [string]$Step,
        [string]$Status,
        [string]$Detail = ''
    )
    $script:RunResults.Add([pscustomobject]@{
            Step   = $Step
            Status = $Status
            Detail = $Detail
        })
}

function Complete-RunAll {
    param([int]$ExitCode = 0)

    if ($ExitCode -ne 0) {
        $script:OverallStatus = 'FAIL'
    }
    elseif ($script:OverallStatus -eq 'OK' -and $script:AppHostPid -gt 0) {
        $script:OverallStatus = 'RUNNING'
    }

    & "$PSScriptRoot\write-last-run-info.ps1" `
        -ExecutionResults $script:RunResults `
        -WebBaseUrl $script:WebBaseUrlFinal `
        -CommandName 'run-all.ps1' `
        -AppHostPid $script:AppHostPid `
        -LogFile $script:LogFile `
        -LogErrFile $script:LogErr `
        -OverallStatus $script:OverallStatus

    exit $ExitCode
}

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
    Add-RunResult -Step 'Restart — stop prior processes' -Status 'OK'
}

if (-not $SkipBuild) {
    Write-Host '[1/7] Debug build + tests...' -ForegroundColor Cyan
    & "$root\build.ps1"
    if ($LASTEXITCODE -ne 0) {
        Add-RunResult -Step '[1/7] Debug build + tests' -Status 'FAIL' -Detail "exit code $LASTEXITCODE"
        Complete-RunAll -ExitCode $LASTEXITCODE
    }
    Add-RunResult -Step '[1/7] Debug build + tests' -Status 'OK'
}
else {
    Write-Host '[1/7] SKIP build (-SkipBuild)' -ForegroundColor DarkGray
    Add-RunResult -Step '[1/7] Debug build + tests' -Status 'SKIP' -Detail '-SkipBuild'
}

if (-not $SkipFlutter) {
    Write-Host '[2/7] Flutter analyze + test...' -ForegroundColor Cyan
    & "$root\scripts\flutter-ci.ps1" -SkipPubGet
    if ($LASTEXITCODE -ne 0) {
        Add-RunResult -Step '[2/7] Flutter analyze + test' -Status 'FAIL' -Detail "exit code $LASTEXITCODE"
        Complete-RunAll -ExitCode $LASTEXITCODE
    }
    Add-RunResult -Step '[2/7] Flutter analyze + test' -Status 'OK'
}
else {
    Write-Host '[2/7] SKIP Flutter (-SkipFlutter)' -ForegroundColor DarkGray
    Add-RunResult -Step '[2/7] Flutter analyze + test' -Status 'SKIP' -Detail '-SkipFlutter'
}

Write-Host '[3/7] Angular SPA -> wwwroot...' -ForegroundColor Cyan
& "$root\scripts\build-spa-to-wwwroot.ps1"
if ($LASTEXITCODE -ne 0) {
    Add-RunResult -Step '[3/7] Angular SPA -> wwwroot' -Status 'FAIL' -Detail "exit code $LASTEXITCODE"
    Complete-RunAll -ExitCode $LASTEXITCODE
}
Add-RunResult -Step '[3/7] Angular SPA -> wwwroot' -Status 'OK'

$logDir = Join-Path $root 'artifacts\logs'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$script:LogFile = Join-Path $logDir ("apphost-{0:yyyyMMdd-HHmmss}.log" -f (Get-Date))
$script:LogErr = "$($script:LogFile).err"

if ($UseRedisContainer) {
    $env:IPNOTE_USE_REDIS_CONTAINER = 'true'
    Add-RunResult -Step 'Redis container' -Status 'OK' -Detail 'IPNOTE_USE_REDIS_CONTAINER=true'
}
else {
    Remove-Item Env:IPNOTE_USE_REDIS_CONTAINER -ErrorAction SilentlyContinue
}

$env:ASPIRE_ALLOW_UNSECURED_TRANSPORT = 'true'
$env:DOTNET_ENVIRONMENT = 'Development'

Write-Host "[4/7] Starting Aspire AppHost (background, log: $($script:LogFile))..." -ForegroundColor Cyan
$appHostProject = Join-Path $root 'src\AppHost\AppHost.csproj'
$runArgs = @('run', '--project', $appHostProject, '--launch-profile', 'http')
if (-not $SkipBuild) {
    $runArgs += '--no-build'
}

$proc = Start-Process -FilePath 'dotnet' -ArgumentList $runArgs -WorkingDirectory $root -PassThru `
    -RedirectStandardOutput $script:LogFile -RedirectStandardError $script:LogErr -WindowStyle Hidden

$script:AppHostPid = $proc.Id
Write-Host "  PID: $($script:AppHostPid)" -ForegroundColor DarkGray
Add-RunResult -Step '[4/7] Aspire AppHost' -Status 'OK' -Detail "PID $($script:AppHostPid)"

if (-not $SkipHealth) {
    Write-Host '[5/7] Discovering Web API URL + health checks...' -ForegroundColor Cyan

    if ([string]::IsNullOrWhiteSpace($WebBaseUrl)) {
        $discovered = & "$root\scripts\discover-web-base-url.ps1" -LogPath $script:LogFile -TimeoutSeconds $StartupWaitSeconds 2>$null
        if ($LASTEXITCODE -ne 0) {
            Add-RunResult -Step '[5/7] Discover Web API URL' -Status 'FAIL' -Detail "timeout ${StartupWaitSeconds}s"
            & "$root\scripts\scan-run-log.ps1" -LogPath $script:LogFile
            if ($proc -and -not $proc.HasExited) { Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue }
            Complete-RunAll -ExitCode 1
        }
        $script:WebBaseUrlFinal = "$discovered".Trim()
        Add-RunResult -Step '[5/7] Discover Web API URL' -Status 'OK' -Detail $script:WebBaseUrlFinal
    }
    else {
        $script:WebBaseUrlFinal = $WebBaseUrl.Trim().TrimEnd('/')
        Add-RunResult -Step '[5/7] Discover Web API URL' -Status 'SKIP' -Detail "-WebBaseUrl $($script:WebBaseUrlFinal)"
    }

    $script:WebBaseUrlFinal = $script:WebBaseUrlFinal.Trim().TrimEnd('/')
    Write-Host "  Using WebBaseUrl: $($script:WebBaseUrlFinal)" -ForegroundColor DarkGray

    & "$root\scripts\verify-health.ps1" -WebBaseUrl $script:WebBaseUrlFinal -WaitSeconds 15
    if ($LASTEXITCODE -ne 0) {
        Add-RunResult -Step '[5/7] Health endpoints' -Status 'FAIL' -Detail 'verify-health.ps1 failed'
        & "$root\scripts\scan-run-log.ps1" -LogPath $script:LogFile
        Complete-RunAll -ExitCode $LASTEXITCODE
    }
    Add-RunResult -Step '[5/7] Health endpoints' -Status 'OK'

    & "$root\scripts\post-deploy-smoke.ps1" -WebBaseUrl $script:WebBaseUrlFinal -WaitSeconds 5 -SkipK6
    if ($LASTEXITCODE -ne 0) {
        Add-RunResult -Step '[5/7] Post-deploy smoke' -Status 'FAIL' -Detail 'post-deploy-smoke.ps1 failed'
        & "$root\scripts\scan-run-log.ps1" -LogPath $script:LogFile
        Complete-RunAll -ExitCode $LASTEXITCODE
    }
    Add-RunResult -Step '[5/7] Post-deploy smoke' -Status 'OK'
}
else {
    Write-Host '[5/7] SKIP health (-SkipHealth)' -ForegroundColor DarkGray
    if ([string]::IsNullOrWhiteSpace($WebBaseUrl)) {
        $script:WebBaseUrlFinal = Get-IpNoteWebBaseUrl
    }
    else {
        $script:WebBaseUrlFinal = $WebBaseUrl.Trim().TrimEnd('/')
    }
    Add-RunResult -Step '[5/7] Health + smoke' -Status 'SKIP' -Detail '-SkipHealth'
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
            Add-RunResult -Step '[6/7] TLS probe (5341)' -Status 'OK' -Detail "$tlsUrl -> 200"
        }
        else {
            Write-Host "WARN [ssl] $tlsUrl -> $($tls.StatusCode)" -ForegroundColor Yellow
            Add-RunResult -Step '[6/7] TLS probe (5341)' -Status 'WARN' -Detail "$tlsUrl -> $($tls.StatusCode)"
            if ($script:OverallStatus -eq 'OK') { $script:OverallStatus = 'PARTIAL' }
        }
    }
    catch {
        Write-Host "WARN [ssl] $tlsUrl not reachable ($($_.Exception.Message)). Run Web with https profile or trust dev cert." -ForegroundColor Yellow
        Add-RunResult -Step '[6/7] TLS probe (5341)' -Status 'WARN' -Detail $_.Exception.Message
        if ($script:OverallStatus -eq 'OK') { $script:OverallStatus = 'PARTIAL' }
    }
}
else {
    Write-Host '[6/7] SKIP TLS (-CheckSsl; use -CheckSsl to probe https://localhost:5341)' -ForegroundColor DarkGray
    Add-RunResult -Step '[6/7] TLS probe (5341)' -Status 'SKIP' -Detail '-CheckSsl not set'
}

Write-Host '[7/7] Log scan...' -ForegroundColor Cyan
if (Test-Path -LiteralPath $script:LogErr) {
    Get-Content -LiteralPath $script:LogErr -ErrorAction SilentlyContinue | Add-Content -LiteralPath $script:LogFile
}
& "$root\scripts\scan-run-log.ps1" -LogPath $script:LogFile
# scan-run-log always exits 0; treat WARN output as partial
Add-RunResult -Step '[7/7] AppHost log scan' -Status 'OK' -Detail $script:LogFile

Write-Host ''
Write-Host '=== Service URLs ===' -ForegroundColor Cyan
@(
    "Aspire dashboard:  $(Get-IpNoteAspireDashboardUrl)",
    "Web API (health):  $($script:WebBaseUrlFinal)/health",
    "Scalar OpenAPI:    $($script:WebBaseUrlFinal)/scalar",
    "Status page:       $($script:WebBaseUrlFinal)/status.html",
    "Changelog:         $($script:WebBaseUrlFinal)/changelog.html",
    "App Links:         $($script:WebBaseUrlFinal)/.well-known/assetlinks.json",
    "Hangfire (dev):    $($script:WebBaseUrlFinal)/hangfire",
    "Angular SPA:       same origin as Web",
    "AppHost log:       $($script:LogFile)",
    "AppHost log (err): $($script:LogErr)",
    "LastRunInfo:       $(Join-Path $root 'LastRunInfo.html')"
) | ForEach-Object { Write-Host "  $_" }

Write-Host ''
Write-Host 'Flutter emulator:' -ForegroundColor DarkGray
Write-Host "  cd src\Mobile\ntk_note_ip_app && flutter run --dart-define=API_BASE_URL=$(Get-IpNoteFlutterEmulatorApiUrl)" -ForegroundColor DarkGray
Write-Host ''
Write-Host 'Stop AppHost: .\scripts\restart-all.ps1 -Restart (or kill dotnet PID above)' -ForegroundColor DarkGray
Write-Host 'Run-all completed. AppHost is still running in background.' -ForegroundColor Green

Complete-RunAll -ExitCode 0
