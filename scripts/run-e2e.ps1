param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Debug"
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

Write-Host "=== IPNote.ir Playwright E2E ===" -ForegroundColor Cyan

Get-Process -Name "Ntk.Note.IP.Web","Ntk.Note.IP.AppHost" -ErrorAction SilentlyContinue |
    Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

dotnet build Ntk.Note.IP.sln -c $Configuration
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$playwrightScript = Join-Path $root "artifacts\bin\Web.AcceptanceTests\$($Configuration.ToLower())\playwright.ps1"
if (-not (Test-Path $playwrightScript)) {
    Write-Error "Playwright script not found at $playwrightScript"
}
pwsh $playwrightScript install --with-deps chromium
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$env:ASPIRE_ALLOW_UNSECURED_TRANSPORT = "true"
$env:DOTNET_ENVIRONMENT = "Development"

dotnet test "tests\Web.AcceptanceTests\Web.AcceptanceTests.csproj" -c $Configuration --no-build --verbosity normal
exit $LASTEXITCODE
