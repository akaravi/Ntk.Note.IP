param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Release",
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$defaultOutput = Join-Path $root "artifacts\publish\web"
if ($Configuration -eq "Debug") {
    $defaultOutput = Join-Path $root "artifacts\publish\web-debug"
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = $defaultOutput
}

$profile = if ($Configuration -eq "Debug") { "FolderProfile-Debug" } else { "FolderProfile" }

Write-Host "=== IPNote.ir publish Web ($Configuration) ===" -ForegroundColor Cyan
Write-Host "Profile: $profile" -ForegroundColor DarkGray
Write-Host "Output: $OutputPath" -ForegroundColor DarkGray

$publishArgs = @(
    (Join-Path $root "src\Web\Web.csproj"),
    "/p:PublishProfile=$profile"
)

if ($OutputPath -ne $defaultOutput) {
    $resolved = (Resolve-Path -LiteralPath (Split-Path $OutputPath -Parent) -ErrorAction SilentlyContinue)?.Path
    if (-not $resolved) {
        New-Item -ItemType Directory -Force -Path (Split-Path $OutputPath -Parent) | Out-Null
        $resolved = (Resolve-Path -LiteralPath (Split-Path $OutputPath -Parent)).Path
    }
    $publishUrl = Join-Path $resolved (Split-Path $OutputPath -Leaf)
    if (-not $publishUrl.EndsWith('\')) { $publishUrl += '\' }
    $publishArgs += "/p:PublishUrl=$publishUrl"
}

dotnet publish @publishArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Publish completed." -ForegroundColor Green
Write-Host "Run: `$env:ASPNETCORE_ENVIRONMENT='Production'; dotnet (Join-Path '$OutputPath' 'Ntk.Note.IP.Web.dll')" -ForegroundColor DarkGray
