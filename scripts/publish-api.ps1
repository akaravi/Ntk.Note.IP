param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Release",
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$defaultOutput = Join-Path $root "publish\dotnet\web"
if ($Configuration -eq "Debug") {
    $defaultOutput = Join-Path $root "publish\dotnet\web-debug"
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = $defaultOutput
}

$profile = if ($Configuration -eq "Debug") { "FolderProfile-Debug" } else { "FolderProfile" }

Write-Host "=== IPNote.ir publish Web ($Configuration) ===" -ForegroundColor Cyan
Write-Host "Profile: $profile" -ForegroundColor DarkGray
Write-Host "Output: $OutputPath" -ForegroundColor DarkGray

New-Item -ItemType Directory -Force -Path $OutputPath | Out-Null
$publishDir = (Resolve-Path -LiteralPath $OutputPath).Path
if (-not $publishDir.EndsWith('\')) {
    $publishDir += '\'
}

$publishArgs = @(
    (Join-Path $root "src\Web\Web.csproj"),
    "/p:PublishProfile=$profile",
    "/p:SatelliteResourceLanguages=en",
    "/p:UseArtifactsOutput=false",
    "/p:PublishDir=$publishDir",
    "/p:PublishUrl=$publishDir"
)

dotnet publish @publishArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& (Join-Path $PSScriptRoot "prune-publish-satellites.ps1") -PublishDir $publishDir.TrimEnd('\')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Publish completed." -ForegroundColor Green
Write-Host "Run: `$env:ASPNETCORE_ENVIRONMENT='Production'; dotnet (Join-Path '$OutputPath' 'Ntk.Note.IP.Web.dll')" -ForegroundColor DarkGray
