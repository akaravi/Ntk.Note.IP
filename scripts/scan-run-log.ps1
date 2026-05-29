param(
    [Parameter(Mandatory = $true)]
    [string]$LogPath,
    [int]$TailLines = 400
)

$ErrorActionPreference = 'Continue'

if (-not (Test-Path -LiteralPath $LogPath)) {
    Write-Host "WARN: log file not found: $LogPath" -ForegroundColor Yellow
    exit 0
}

$lines = Get-Content -LiteralPath $LogPath -Tail $TailLines -ErrorAction SilentlyContinue
if (-not $lines) {
    exit 0
}

$pattern = '(?i)\b(fail|fatal|crit|error|exception|unhandled)\b'
$hits = @()
foreach ($line in $lines) {
    if ($line -match $pattern -and $line -notmatch '(?i)(0 error|no error|errorMessage.*null|Failed to bind)') {
        $hits += $line
    }
}

if ($hits.Count -eq 0) {
    Write-Host "OK  [log] no suspicious error lines in tail of $LogPath" -ForegroundColor Green
    exit 0
}

Write-Host "WARN [log] $($hits.Count) suspicious line(s) in $LogPath" -ForegroundColor Yellow
$hits | Select-Object -Last 15 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkYellow }
exit 0
