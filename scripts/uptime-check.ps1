param(
    [switch]$IncludeStaging,
    [switch]$IncludeProduction,
    [switch]$RequireTls,
    [int]$WaitSeconds = 45
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent

$stagingUrl = $env:STAGING_WEB_BASE_URL
$productionUrl = $env:PRODUCTION_WEB_BASE_URL

if (-not $IncludeStaging -and -not $IncludeProduction) {
    $IncludeStaging = -not [string]::IsNullOrWhiteSpace($stagingUrl)
    $IncludeProduction = -not [string]::IsNullOrWhiteSpace($productionUrl)
}

$targets = [System.Collections.Generic.List[object]]::new()
if ($IncludeStaging -and -not [string]::IsNullOrWhiteSpace($stagingUrl)) {
    $targets.Add([pscustomobject]@{ Name = "staging"; Url = $stagingUrl.Trim().TrimEnd('/') })
}
if ($IncludeProduction -and -not [string]::IsNullOrWhiteSpace($productionUrl)) {
    $targets.Add([pscustomobject]@{ Name = "production"; Url = $productionUrl.Trim().TrimEnd('/') })
}

if ($targets.Count -eq 0) {
    Write-Host "SKIP: No targets. Set STAGING_WEB_BASE_URL and/or PRODUCTION_WEB_BASE_URL." -ForegroundColor DarkGray
    exit 0
}

Write-Host "=== IPNote.ir uptime check ($($targets.Count) target(s)) ===" -ForegroundColor Cyan

$failed = $false
foreach ($target in $targets) {
    if ($RequireTls -and -not $target.Url.StartsWith('https://', [StringComparison]::OrdinalIgnoreCase)) {
        Write-Host "FAIL [$($target.Name)] URL must be https when -RequireTls is set: $($target.Url)" -ForegroundColor Red
        $failed = $true
        continue
    }

    Write-Host "--- $($target.Name): $($target.Url) ---" -ForegroundColor Cyan
    & "$root\scripts\verify-health.ps1" -WebBaseUrl $target.Url -WaitSeconds $WaitSeconds
    if ($LASTEXITCODE -ne 0) {
        $failed = $true
    }
}

if ($failed) {
    Write-Host "Uptime check FAILED." -ForegroundColor Red
    exit 1
}

Write-Host "Uptime check passed." -ForegroundColor Green
exit 0
