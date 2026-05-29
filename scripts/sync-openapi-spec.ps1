param(
    [string]$Source = '',
    [string]$Destination = ''
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent

if ([string]::IsNullOrWhiteSpace($Source)) {
    $Source = Join-Path $root 'src\Web\wwwroot\openapi\v1.json'
}

if ([string]::IsNullOrWhiteSpace($Destination)) {
    $Destination = Join-Path $root 'src\Mobile\ntk_note_ip_app\openapi\v1.json'
}

if (-not (Test-Path -LiteralPath $Source)) {
    Write-Error "OpenAPI source not found: $Source"
}

$destDir = Split-Path $Destination -Parent
New-Item -ItemType Directory -Force -Path $destDir | Out-Null
Copy-Item -LiteralPath $Source -Destination $Destination -Force

Write-Host "Synced OpenAPI spec -> $Destination" -ForegroundColor Green
