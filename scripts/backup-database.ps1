param(
    [string]$ConnectionString = "",
    [string]$OutputDir = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent

if ([string]::IsNullOrWhiteSpace($OutputDir)) {
    $OutputDir = Join-Path $root "artifacts\backup"
}

if ([string]::IsNullOrWhiteSpace($ConnectionString)) {
    $appSettings = Join-Path $root "src\Web\appsettings.json"
    if (-not (Test-Path $appSettings)) {
        Write-Host "FAIL: appsettings.json not found and -ConnectionString not provided." -ForegroundColor Red
        exit 1
    }
    $json = Get-Content $appSettings -Raw | ConvertFrom-Json
    $ConnectionString = $json.ConnectionStrings.IPNoteDb
}

if ([string]::IsNullOrWhiteSpace($ConnectionString)) {
    Write-Host "FAIL: Connection string is empty." -ForegroundColor Red
    exit 1
}

$dbPath = $null
if ($ConnectionString -match 'Data Source=([^;]+)') {
    $dbPath = $Matches[1].Trim()
}
elseif ($ConnectionString -match 'DataSource=([^;]+)') {
    $dbPath = $Matches[1].Trim()
}

if ([string]::IsNullOrWhiteSpace($dbPath)) {
    Write-Host "FAIL: Only SQLite file backups are supported by this script. Use pg_dump for PostgreSQL." -ForegroundColor Red
    exit 1
}

if (-not [System.IO.Path]::IsPathRooted($dbPath)) {
    $dbPath = Join-Path $root "src\Web\$dbPath"
}

if (-not (Test-Path $dbPath)) {
    Write-Host "FAIL: Database file not found: $dbPath" -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($dbPath)
$dest = Join-Path $OutputDir "$baseName-$stamp.db"

Copy-Item -Path $dbPath -Destination $dest -Force
Write-Host "Backup created: $dest" -ForegroundColor Green
Write-Host "Size: $((Get-Item $dest).Length) bytes" -ForegroundColor DarkGray

exit 0
