param(
    [string]$WebBaseUrl = "http://localhost:8080",
    [int]$WaitSeconds = 90,
    [switch]$SkipK6,
    [switch]$SkipSpa,
    [switch]$RequireTls,
    [switch]$StrictDeepLinks
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent

$WebBaseUrl = $WebBaseUrl.Trim().TrimEnd('/')
if ([string]::IsNullOrWhiteSpace($WebBaseUrl)) {
    Write-Host "FAIL: WebBaseUrl is required." -ForegroundColor Red
    exit 1
}

if ($RequireTls -and -not $WebBaseUrl.StartsWith('https://', [StringComparison]::OrdinalIgnoreCase)) {
    Write-Host "FAIL: RequireTls is set but URL is not https:// ($WebBaseUrl)" -ForegroundColor Red
    exit 1
}

Write-Host "=== IPNote.ir post-deploy smoke ===" -ForegroundColor Cyan
Write-Host "Target: $WebBaseUrl" -ForegroundColor DarkGray

& "$root\scripts\verify-health.ps1" -WebBaseUrl $WebBaseUrl -WaitSeconds $WaitSeconds
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if (-not $SkipSpa) {
    try {
        $spaRoot = Invoke-WebRequest -Uri $WebBaseUrl -UseBasicParsing -TimeoutSec 15
        if ($spaRoot.StatusCode -ne 200) {
            Write-Host "FAIL: SPA root returned $($spaRoot.StatusCode)" -ForegroundColor Red
            exit 1
        }
        Write-Host "OK  [spa] $WebBaseUrl -> 200" -ForegroundColor Green
    }
    catch {
        Write-Host "FAIL: SPA root -> $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "SKIP [spa] -SkipSpa" -ForegroundColor DarkGray
}

if (-not $SkipK6 -and (Get-Command k6 -ErrorAction SilentlyContinue)) {
    & "$root\scripts\run-k6-smoke.ps1" -BaseUrl $WebBaseUrl
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
elseif (-not $SkipK6) {
    Write-Host "k6 not installed; skipping load smoke." -ForegroundColor DarkGray
}

$wellKnown = @(
    @{ Path = '/.well-known/assetlinks.json'; ExpectJson = $true },
    @{ Path = '/.well-known/apple-app-site-association'; ExpectJson = $true },
    @{ Path = '/changelog.html'; ExpectJson = $false },
    @{ Path = '/CHANGELOG.md'; ExpectJson = $false },
    @{ Path = '/status.html'; ExpectJson = $false }
)

foreach ($item in $wellKnown) {
    $url = "$WebBaseUrl$($item.Path)"
    try {
        $resp = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 15
        if ($resp.StatusCode -ne 200) {
            Write-Host "FAIL: $url -> $($resp.StatusCode)" -ForegroundColor Red
            exit 1
        }
        if ($item.ExpectJson -and $resp.Headers['Content-Type'] -notmatch 'json') {
            Write-Host "WARN: $url Content-Type may not be JSON ($($resp.Headers['Content-Type']))" -ForegroundColor Yellow
        }
        Write-Host "OK  [well-known] $url -> 200" -ForegroundColor Green
    }
    catch {
        Write-Host "FAIL: $url -> $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

& "$root\scripts\verify-deep-links-placeholders.ps1" -Strict:$StrictDeepLinks
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Post-deploy smoke passed." -ForegroundColor Green
