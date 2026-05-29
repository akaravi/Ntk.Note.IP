param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Debug"
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

Write-Host "Applying EF Core migrations..." -ForegroundColor Cyan

$provider = $env:Database__Provider
if (-not $provider) {
    $provider = "Sqlite"
    if ($env:ASPNETCORE_ENVIRONMENT -eq "Production") {
        $provider = "SqlServer"
    }
}

$migrationsProject = if ($provider -match "^(SqlServer|MSSQL)$") {
    "src\Infrastructure.SqlServer\Infrastructure.SqlServer.csproj"
} else {
    "src\Infrastructure\Infrastructure.csproj"
}

Write-Host "Provider: $provider | Migrations project: $migrationsProject" -ForegroundColor DarkCyan

dotnet ef database update `
    --project $migrationsProject `
    --startup-project "src\Web\Web.csproj" `
    --configuration $Configuration

if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Database migration completed." -ForegroundColor Green
