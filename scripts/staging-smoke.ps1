param(
    [string]$WebBaseUrl = $env:STAGING_WEB_BASE_URL,
    [int]$WaitSeconds = 60,
    [switch]$SkipK6,
    [switch]$SkipSpa,
    [switch]$RequireTls
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent

if ([string]::IsNullOrWhiteSpace($WebBaseUrl)) {
    Write-Host "FAIL: Set -WebBaseUrl or environment variable STAGING_WEB_BASE_URL." -ForegroundColor Red
    Write-Host "Example: .\scripts\staging-smoke.ps1 -WebBaseUrl https://staging.ipnote.ir -RequireTls" -ForegroundColor DarkGray
    exit 1
}

Write-Host "=== IPNote.ir staging smoke ===" -ForegroundColor Cyan

$smokeParams = @{
    WebBaseUrl  = $WebBaseUrl
    WaitSeconds = $WaitSeconds
}
if ($SkipK6) { $smokeParams.SkipK6 = $true }
if ($SkipSpa) { $smokeParams.SkipSpa = $true }
if ($RequireTls) { $smokeParams.RequireTls = $true }

& "$root\scripts\post-deploy-smoke.ps1" @smokeParams
exit $LASTEXITCODE
