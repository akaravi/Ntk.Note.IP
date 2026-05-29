param(
    [switch]$SkipSync,
    [switch]$SkipBuildRunner
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$appDir = Join-Path $root 'src\Mobile\ntk_note_ip_app'

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error 'Flutter SDK not found on PATH.'
}

if (-not $SkipSync) {
    & "$root\scripts\sync-openapi-spec.ps1"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Set-Location $appDir
Write-Host '=== IPNote.ir Flutter OpenAPI codegen ===' -ForegroundColor Cyan

flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

dart run swagger_parser -f swagger_parser.yaml
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if (-not $SkipBuildRunner) {
    dart run build_runner build --delete-conflicting-outputs
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Write-Host 'OpenAPI codegen completed.' -ForegroundColor Green
