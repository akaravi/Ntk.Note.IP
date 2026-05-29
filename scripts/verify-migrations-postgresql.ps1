param(
    [string]$ConnectionString = "",
    [int]$WaitSeconds = 60
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

if ([string]::IsNullOrWhiteSpace($ConnectionString)) {
    $ConnectionString = $env:ConnectionStrings__IPNoteDb
}

if ([string]::IsNullOrWhiteSpace($ConnectionString)) {
    $ConnectionString = "Host=127.0.0.1;Port=5432;Database=ipnote;Username=ipnote;Password=ipnote;"
}

$env:ConnectionStrings__IPNoteDb = $ConnectionString
$env:Database__Provider = "PostgreSQL"

Write-Host "=== IPNote.ir verify migrations (PostgreSQL) ===" -ForegroundColor Cyan
Write-Host "Connection: $ConnectionString" -ForegroundColor DarkGray

$deadline = (Get-Date).AddSeconds($WaitSeconds)
$applied = $false

while ((Get-Date) -lt $deadline) {
    & "$root\scripts\migrate-database.ps1" -Configuration Release
    if ($LASTEXITCODE -eq 0) {
        $applied = $true
        break
    }
    Write-Host "PostgreSQL not ready or migrate failed; retrying..." -ForegroundColor DarkGray
    Start-Sleep -Seconds 3
}

if (-not $applied) {
    Write-Host "FAIL: Migrations did not apply on PostgreSQL within ${WaitSeconds}s." -ForegroundColor Red
    exit 1
}

Write-Host "PostgreSQL migrations apply successfully." -ForegroundColor Green
