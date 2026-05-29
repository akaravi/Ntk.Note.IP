param(
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $root "artifacts\migrate-idempotent.sql"
}

$dir = Split-Path $OutputPath -Parent
if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

Write-Host "=== IPNote.ir migration SQL script ===" -ForegroundColor Cyan
Write-Host "Output: $OutputPath" -ForegroundColor DarkGray

$efBase = @(
    "ef", "migrations", "script",
    "--project", "src\Infrastructure\Infrastructure.csproj",
    "--startup-project", "src\Web\Web.csproj",
    "--configuration", "Release",
    "--output", $OutputPath
)

Write-Host "Trying idempotent script (PostgreSQL/SQL Server)..." -ForegroundColor DarkGray
dotnet @efBase --idempotent -i
if ($LASTEXITCODE -ne 0) {
    Write-Host "Idempotent script not supported for current provider; generating standard script." -ForegroundColor Yellow
    dotnet @efBase
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

if (-not (Test-Path $OutputPath)) {
    Write-Error "Migration script was not created."
}

$length = (Get-Item $OutputPath).Length
if ($length -lt 32) {
    Write-Error "Migration script looks empty ($length bytes)."
}

Write-Host "Migration script generated ($length bytes)." -ForegroundColor Green
