param(
    [switch]$Strict
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent

$paths = @(
    (Join-Path $root "src\Web\wwwroot\.well-known\assetlinks.json"),
    (Join-Path $root "src\Web\wwwroot\.well-known\apple-app-site-association")
)

$placeholders = @(
    'REPLACE_WITH_RELEASE_KEY_SHA256',
    'TEAMID'
)

$found = @()
foreach ($file in $paths) {
    if (-not (Test-Path $file)) {
        $found += "Missing file: $file"
        continue
    }

    $content = Get-Content -Path $file -Raw
    foreach ($token in $placeholders) {
        if ($content -match [regex]::Escape($token)) {
            $found += "$file contains placeholder '$token'"
        }
    }
}

if ($found.Count -eq 0) {
    Write-Host "Deep link verification files have no known placeholders." -ForegroundColor Green
    exit 0
}

foreach ($line in $found) {
    if ($Strict) {
        Write-Host "FAIL: $line" -ForegroundColor Red
    }
    else {
        Write-Host "WARN: $line" -ForegroundColor Yellow
    }
}

if ($Strict) {
    Write-Host "Fix with: .\scripts\update-deep-links.ps1 -AndroidReleaseSha256 <sha> -AppleTeamId <team>" -ForegroundColor DarkGray
    exit 1
}

Write-Host "Use -Strict to fail CI/smoke when placeholders remain." -ForegroundColor DarkGray
exit 0
