param(
    [switch]$KeepRunning,
    [switch]$SkipK6,
    [switch]$WithRedis
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

$composeArgs = @("-f", "docker-compose.prod.yml")
if ($WithRedis) {
    $composeArgs += "-f", "docker-compose.prod.redis.yml"
}

Write-Host "=== IPNote.ir docker prod smoke ===" -ForegroundColor Cyan

docker compose @composeArgs down -v 2>$null
docker compose @composeArgs up --build -d
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

try {
    & "$root\scripts\post-deploy-smoke.ps1" -WebBaseUrl "http://localhost:8080" -SkipK6:$SkipK6
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
finally {
    if (-not $KeepRunning) {
        Write-Host "Stopping compose stack..." -ForegroundColor DarkGray
        docker compose @composeArgs down -v
    }
    else {
        Write-Host "Stack left running at http://localhost:8080" -ForegroundColor Green
    }
}

Write-Host "Docker prod smoke completed." -ForegroundColor Green
