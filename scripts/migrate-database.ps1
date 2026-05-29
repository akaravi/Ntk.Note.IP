param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Debug"
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

Write-Host "Applying EF Core migrations (startup: Web, project: Infrastructure)..." -ForegroundColor Cyan

dotnet ef database update `
    --project "src\Infrastructure\Infrastructure.csproj" `
    --startup-project "src\Web\Web.csproj" `
    --configuration $Configuration

if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Database migration completed." -ForegroundColor Green
