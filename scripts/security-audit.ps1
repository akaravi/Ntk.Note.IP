param(
    [switch]$FailOnVulnerabilities
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

Write-Host "=== IPNote.ir security audit ===" -ForegroundColor Cyan
$exitCode = 0

Write-Host "`n[NuGet] dotnet list package --vulnerable" -ForegroundColor Yellow
dotnet list Ntk.Note.IP.sln package --vulnerable --include-transitive 2>&1 | Tee-Object -Variable nugetOut
if ($LASTEXITCODE -ne 0) { $exitCode = 1 }

if ($nugetOut -match "has the following vulnerable") {
    Write-Host "Vulnerable NuGet packages reported." -ForegroundColor Red
    if ($FailOnVulnerabilities) { $exitCode = 1 }
}

$clientApp = Join-Path $root "src\Web\ClientApp"
if (Test-Path (Join-Path $clientApp "package-lock.json")) {
    Write-Host "`n[npm] audit (ClientApp)" -ForegroundColor Yellow
    Push-Location $clientApp
    try {
        npm audit --audit-level=high 2>&1 | Tee-Object -Variable npmOut
        if ($LASTEXITCODE -ne 0) {
            if ($FailOnVulnerabilities) { $exitCode = 1 }
        }
    }
    finally {
        Pop-Location
    }
}

Write-Host ""
if ($exitCode -eq 0) {
    Write-Host "Security audit completed (no failing gate)." -ForegroundColor Green
}
else {
    Write-Host "Security audit reported issues." -ForegroundColor Red
}

exit $exitCode
