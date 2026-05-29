param(
    [switch]$SkipNpmInstall
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$clientApp = Join-Path $root 'src\Web\ClientApp'
$wwwRoot = Join-Path $root 'src\Web\wwwroot'
$distBrowser = Join-Path $clientApp 'dist\browser'

if (-not (Test-Path -LiteralPath $clientApp)) {
    Write-Error "Angular ClientApp not found: $clientApp"
}

Push-Location $clientApp
try {
    if (-not $SkipNpmInstall) {
        Write-Host 'npm install (ClientApp)...' -ForegroundColor Cyan
        npm install --no-fund --no-audit
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }

    Write-Host 'npm run build (ClientApp production)...' -ForegroundColor Cyan
    npm run build -- --configuration production
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
finally {
    Pop-Location
}

if (-not (Test-Path -LiteralPath (Join-Path $distBrowser 'index.html'))) {
    Write-Error "Angular build output missing: $distBrowser\index.html"
}

Write-Host "Copying SPA assets -> $wwwRoot" -ForegroundColor Cyan
Get-ChildItem -LiteralPath $distBrowser -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $wwwRoot -Recurse -Force
}

Write-Host 'SPA published to wwwroot.' -ForegroundColor Green
