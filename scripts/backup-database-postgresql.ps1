param(
    [string]$ConnectionString = "",
    [string]$OutputDir = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent

if ([string]::IsNullOrWhiteSpace($ConnectionString)) {
    $ConnectionString = $env:ConnectionStrings__IPNoteDb
}

if ([string]::IsNullOrWhiteSpace($ConnectionString)) {
    Write-Host "FAIL: Set -ConnectionString or ConnectionStrings__IPNoteDb." -ForegroundColor Red
    exit 1
}

if ([string]::IsNullOrWhiteSpace($OutputDir)) {
    $OutputDir = Join-Path $root "artifacts\backup"
}

function Get-ConnValue([string]$key) {
    if ($ConnectionString -match "(?i)$key=([^;]+)") {
        return $Matches[1].Trim()
    }
    return $null
}

$hostName = Get-ConnValue 'Host'
if (-not $hostName) { $hostName = Get-ConnValue 'Server' }
$port = Get-ConnValue 'Port'
if (-not $port) { $port = '5432' }
$database = Get-ConnValue 'Database'
$username = Get-ConnValue 'Username'
if (-not $username) { $username = Get-ConnValue 'User ID' }
$password = Get-ConnValue 'Password'

if ([string]::IsNullOrWhiteSpace($hostName) -or [string]::IsNullOrWhiteSpace($database)) {
    Write-Host "FAIL: Could not parse Host and Database from connection string." -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$dest = Join-Path $OutputDir "ipnote-pg-$stamp.dump"

Write-Host "=== IPNote.ir PostgreSQL backup ===" -ForegroundColor Cyan
Write-Host "Target: $dest" -ForegroundColor DarkGray

$pgDump = Get-Command pg_dump -ErrorAction SilentlyContinue
if ($pgDump) {
    $env:PGPASSWORD = $password
    & pg_dump -h $hostName -p $port -U $username -d $database -Fc -f $dest
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
elseif (Get-Command docker -ErrorAction SilentlyContinue) {
    $dockerHost = if ($hostName -eq 'localhost' -or $hostName -eq '127.0.0.1') { 'host.docker.internal' } else { $hostName }
    $outDir = (Resolve-Path $OutputDir).Path
    $fileName = [System.IO.Path]::GetFileName($dest)
    docker run --rm `
        -e PGPASSWORD=$password `
        -v "${outDir}:/backup" `
        postgres:16-alpine `
        pg_dump -h $dockerHost -p $port -U $username -d $database -Fc -f "/backup/$fileName"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
else {
    Write-Host "FAIL: Install pg_dump or Docker to run backups." -ForegroundColor Red
    exit 1
}

Write-Host "Backup created: $dest ($((Get-Item $dest).Length) bytes)" -ForegroundColor Green
