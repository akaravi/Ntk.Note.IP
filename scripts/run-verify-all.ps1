param(
    [switch]$SkipBuild,
    [switch]$SkipFlutter,
    [switch]$SkipTests,
    [switch]$IncludeE2e,
    [switch]$Coverage,
    [switch]$StartAppHost,
    [string]$WebBaseUrl = ''
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
. "$PSScriptRoot\local-dev-ports.ps1"
if ([string]::IsNullOrWhiteSpace($WebBaseUrl)) {
    $WebBaseUrl = Get-IpNoteWebBaseUrl
}
Set-Location $root

Write-Host "=== IPNote.ir verify-all ===" -ForegroundColor Cyan

& "$root\scripts\verify-no-external-cdn.ps1"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if (-not $SkipFlutter) {
    & "$root\scripts\flutter-ci.ps1"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

if (-not $SkipBuild) {
    if ($Coverage) {
        & "$root\build.ps1" -Coverage
    }
    elseif (-not $SkipTests) {
        & "$root\build.ps1"
    }
    else {
        & "$root\build.ps1" -SkipTests
    }
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
elseif ($Coverage) {
    & "$root\scripts\coverage.ps1"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

if ($IncludeE2e) {
    & "$root\scripts\run-e2e.ps1"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

if ($StartAppHost) {
    Write-Host "Starting AppHost in background..." -ForegroundColor Cyan
    $env:ASPIRE_ALLOW_UNSECURED_TRANSPORT = "true"
    $env:DOTNET_ENVIRONMENT = "Development"
    Start-Process -FilePath "dotnet" -ArgumentList @(
        "run",
        "--project", "$root\src\AppHost\AppHost.csproj",
        "--launch-profile", "http",
        "--no-build"
    ) -WorkingDirectory $root -WindowStyle Minimized
    Start-Sleep -Seconds 5
}

& "$root\scripts\verify-health.ps1" -WebBaseUrl $WebBaseUrl
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ""
Write-Host "=== Service URLs (typical dev) ===" -ForegroundColor Cyan
@(
    "Aspire dashboard: $(Get-IpNoteAspireDashboardUrl)",
    "Angular dev (Aspire): http://localhost:$($script:IpNoteDevPorts.SpaHttp)",
    "Web API:          $WebBaseUrl",
    "Scalar OpenAPI:   $WebBaseUrl/scalar",
    "Health:           $WebBaseUrl/health",
    "Status page:      $WebBaseUrl/status.html",
    "Changelog:        $WebBaseUrl/changelog.html",
    "App Links:        $WebBaseUrl/.well-known/assetlinks.json",
    "Hangfire:         $WebBaseUrl/hangfire (Development, local only)",
    "Angular SPA:      served with Web (same origin)"
) | ForEach-Object { Write-Host "  $_" }

Write-Host ""
Write-Host "Flutter: cd src\Mobile\ntk_note_ip_app && flutter run --dart-define=API_BASE_URL=$(Get-IpNoteFlutterEmulatorApiUrl)" -ForegroundColor DarkGray
Write-Host "Verify-all completed." -ForegroundColor Green
