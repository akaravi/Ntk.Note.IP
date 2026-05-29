param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Release",
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $root "artifacts\publish\web"
}

Write-Host "=== IPNote.ir publish Web ($Configuration) ===" -ForegroundColor Cyan
Write-Host "Output: $OutputPath" -ForegroundColor DarkGray

if (Test-Path $OutputPath) {
    Remove-Item -Recurse -Force $OutputPath
}

dotnet publish (Join-Path $root "src\Web\Web.csproj") -c $Configuration -o $OutputPath /p:UseAppHost=false
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Publish completed." -ForegroundColor Green
Write-Host "Run: `$env:ASPNETCORE_ENVIRONMENT='Production'; dotnet (Join-Path '$OutputPath' 'Ntk.Note.IP.Web.dll')" -ForegroundColor DarkGray
