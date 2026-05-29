param(
    [switch]$SkipPubGet
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot | Split-Path -Parent
$appDir = Join-Path $root "src\Mobile\ntk_note_ip_app"

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter SDK not found on PATH. Install from https://docs.flutter.dev/get-started/install"
}

Set-Location $appDir
Write-Host "=== IPNote.ir Flutter CI ===" -ForegroundColor Cyan

if (-not $SkipPubGet) {
    flutter pub get
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

flutter gen-l10n
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

dart analyze --fatal-infos
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Flutter CI completed." -ForegroundColor Green
