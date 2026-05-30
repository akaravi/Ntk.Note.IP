param(
    [string]$ApiBaseUrl = 'https://ipnote.ir',

    [switch]$SkipCi
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$appDir = Join-Path $root "src\Mobile\ntk_note_ip_app"
$webOutDir = Join-Path $appDir "build\web"

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter SDK not found on PATH."
}

if (-not (Test-Path -LiteralPath (Join-Path $appDir "web\index.html"))) {
    Write-Error "Flutter web platform not found. Run 'flutter create --platforms=web' in $appDir"
}

if (-not $SkipCi) {
    & "$root\scripts\flutter-ci.ps1"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

& "$root\scripts\verify-no-external-cdn.ps1"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Set-Location $appDir
& "$root\scripts\flutter-pub-get.ps1"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter gen-l10n
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$defineArgs = @('--dart-define=API_BASE_URL=' + $ApiBaseUrl)
Write-Host "=== IPNote.ir Flutter web release build ===" -ForegroundColor Cyan
Write-Host "API_BASE_URL=$ApiBaseUrl" -ForegroundColor DarkGray
Write-Host "CanvasKit: bundled locally (--no-web-resources-cdn; no gstatic.com CDN)" -ForegroundColor DarkGray

& flutter build web --release --no-web-resources-cdn @defineArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if (-not (Test-Path -LiteralPath (Join-Path $webOutDir "index.html"))) {
    Write-Error "Flutter web build output missing: $webOutDir\index.html"
}

Write-Host ""
Write-Host "Web artifacts under:" -ForegroundColor Cyan
Write-Host "  $webOutDir" -ForegroundColor Green
Write-Host ""
Write-Host "Serve locally: flutter run -d chrome --web-port=5349 --no-web-resources-cdn --dart-define=API_BASE_URL=http://localhost:5340" -ForegroundColor DarkGray
