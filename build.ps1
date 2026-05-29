<#
  Quick .NET build + tests. Full stack (SPA, Flutter, package ZIP, dev servers):
  .\_build-all-projects.ps1 -SkipPackage
#>
param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Debug",
    [switch]$SkipTests,
    [switch]$SkipRestore,
    [switch]$SkipStopRunningProjects,
    [switch]$Coverage
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
Set-Location $root

if (-not $SkipStopRunningProjects) {
    Get-Process -Name "Ntk.Note.IP.AppHost", "Ntk.Note.IP.Web" -ErrorAction SilentlyContinue |
        Stop-Process -Force -ErrorAction SilentlyContinue
}

Write-Host "=== IPNote.ir build ($Configuration) ===" -ForegroundColor Cyan

if (-not $SkipRestore) {
    dotnet restore Ntk.Note.IP.sln
}

dotnet build Ntk.Note.IP.sln -c $Configuration --no-restore
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if ($Coverage) {
    & "$root\scripts\coverage.ps1" -Configuration $Configuration -SkipBuild
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
elseif (-not $SkipTests) {
    $testProjects = @(
        "tests\Architecture.UnitTests\Architecture.UnitTests.csproj",
        "tests\Domain.UnitTests\Domain.UnitTests.csproj",
        "tests\Application.UnitTests\Application.UnitTests.csproj",
        "tests\Application.FunctionalTests\Application.FunctionalTests.csproj"
    )
    foreach ($proj in $testProjects) {
        dotnet test $proj -c $Configuration --no-build --verbosity minimal
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }
}

& "$root\scripts\check-i18n-keys.ps1"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Build pipeline completed." -ForegroundColor Green
