param(
    [string]$BaseUrl = '',
    [int]$WaitSeconds = 0
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
. "$PSScriptRoot\local-dev-ports.ps1"
if ([string]::IsNullOrWhiteSpace($BaseUrl)) {
    $BaseUrl = Get-IpNoteWebBaseUrl
}

if (-not (Get-Command k6 -ErrorAction SilentlyContinue)) {
    Write-Host "k6 is not installed. Install from https://k6.io/docs/get-started/installation/" -ForegroundColor Yellow
    Write-Host "Example: winget install k6 --source winget" -ForegroundColor DarkGray
    exit 1
}

if ($WaitSeconds -gt 0) {
    Write-Host "Waiting ${WaitSeconds}s for $BaseUrl ..."
    Start-Sleep -Seconds $WaitSeconds
}

$scriptPath = Join-Path $root "tests\load\smoke.js"
Write-Host "=== k6 smoke load ($BaseUrl) ===" -ForegroundColor Cyan

$env:BASE_URL = $BaseUrl
k6 run $scriptPath
exit $LASTEXITCODE
