param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Debug",
    [int]$MinLinePercent = 40,
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

$coverageRoot = Join-Path $root "artifacts\coverage"
if (Test-Path $coverageRoot) {
    Remove-Item -Recurse -Force $coverageRoot
}
New-Item -ItemType Directory -Path $coverageRoot -Force | Out-Null

Write-Host "=== IPNote.ir backend coverage ($Configuration, min ${MinLinePercent}%) ===" -ForegroundColor Cyan

if (-not $SkipBuild) {
    dotnet build Ntk.Note.IP.sln -c $Configuration
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$testProjects = @(
    "tests\Domain.UnitTests\Domain.UnitTests.csproj",
    "tests\Application.UnitTests\Application.UnitTests.csproj",
    "tests\Application.FunctionalTests\Application.FunctionalTests.csproj"
)

foreach ($proj in $testProjects) {
    Write-Host "Testing with coverage: $proj" -ForegroundColor DarkGray
    dotnet test $proj -c $Configuration --no-build --settings coverlet.runsettings --results-directory $coverageRoot
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$coberturaFiles = Get-ChildItem $coverageRoot -Recurse -Filter "coverage.cobertura.xml" -ErrorAction SilentlyContinue
if (-not $coberturaFiles) {
    Write-Error "No coverage.cobertura.xml files found under $coverageRoot"
}

$linesValid = 0
$linesCovered = 0
foreach ($file in $coberturaFiles) {
    [xml]$doc = Get-Content $file.FullName
    $linesValid += [int]$doc.coverage.'lines-valid'
    $linesCovered += [int]$doc.coverage.'lines-covered'
}

$linePercent = if ($linesValid -gt 0) {
    [math]::Round(100.0 * $linesCovered / $linesValid, 1)
} else {
    0.0
}

Write-Host ""
Write-Host "Line coverage: $linesCovered / $linesValid ($linePercent%)" -ForegroundColor Cyan
Write-Host "Reports: $coverageRoot" -ForegroundColor DarkGray

if ($linePercent -lt $MinLinePercent) {
    Write-Host "Coverage gate FAILED: $linePercent% < $MinLinePercent%" -ForegroundColor Red
    exit 1
}

Write-Host "Coverage gate passed (>= $MinLinePercent%)." -ForegroundColor Green
