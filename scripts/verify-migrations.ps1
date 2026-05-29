param(
    [string]$DatabasePath = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

if ([string]::IsNullOrWhiteSpace($DatabasePath)) {
    $tempRoot = if ($env:RUNNER_TEMP) { $env:RUNNER_TEMP } else { Join-Path $root "artifacts" }
    if (-not (Test-Path $tempRoot)) {
        New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
    }
    $DatabasePath = Join-Path $tempRoot "ipnote-migrate-verify.db"
}

if (Test-Path $DatabasePath) {
    Remove-Item -Force $DatabasePath
}

$env:ConnectionStrings__IPNoteDb = "Data Source=$DatabasePath"

Write-Host "=== IPNote.ir verify migrations ===" -ForegroundColor Cyan
Write-Host "Database: $DatabasePath" -ForegroundColor DarkGray

& "$root\scripts\migrate-database.ps1" -Configuration Release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if (-not (Test-Path $DatabasePath)) {
    Write-Error "Database file was not created after migration."
}

Write-Host "Migrations apply successfully." -ForegroundColor Green
