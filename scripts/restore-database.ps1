param(
    [Parameter(Mandatory = $true)]
    [string]$BackupFile,
    [string]$ConnectionString = "",
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent

if (-not (Test-Path $BackupFile)) {
    Write-Host "FAIL: Backup file not found: $BackupFile" -ForegroundColor Red
    exit 1
}

if ([string]::IsNullOrWhiteSpace($ConnectionString)) {
    $appSettings = Join-Path $root "src\Web\appsettings.json"
    $json = Get-Content $appSettings -Raw | ConvertFrom-Json
    $ConnectionString = $json.ConnectionStrings.IPNoteDb
}

$dbPath = $null
if ($ConnectionString -match 'Data Source=([^;]+)') {
    $dbPath = $Matches[1].Trim()
}
elseif ($ConnectionString -match 'DataSource=([^;]+)') {
    $dbPath = $Matches[1].Trim()
}

if ([string]::IsNullOrWhiteSpace($dbPath)) {
    Write-Host "FAIL: Only SQLite restore is supported. Use psql/pg_restore for PostgreSQL." -ForegroundColor Red
    exit 1
}

if (-not [System.IO.Path]::IsPathRooted($dbPath)) {
    $dbPath = Join-Path $root "src\Web\$dbPath"
}

if ((Test-Path $dbPath) -and -not $Force) {
    Write-Host "Target exists: $dbPath" -ForegroundColor Yellow
    Write-Host "Re-run with -Force to overwrite after stopping the Web app." -ForegroundColor Yellow
    exit 1
}

$parent = Split-Path $dbPath -Parent
if (-not [string]::IsNullOrWhiteSpace($parent)) {
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
}

Copy-Item -Path $BackupFile -Destination $dbPath -Force
Write-Host "Restored $BackupFile -> $dbPath" -ForegroundColor Green
exit 0
