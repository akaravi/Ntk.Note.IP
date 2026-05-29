param(
    [string]$WebBaseUrl = '',
    [int]$WaitSeconds = 45
)

$ErrorActionPreference = "Continue"
. "$PSScriptRoot\local-dev-ports.ps1"
if ([string]::IsNullOrWhiteSpace($WebBaseUrl)) {
    $WebBaseUrl = Get-IpNoteWebBaseUrl
}
$endpoints = @(
    @{ Name = "health"; Path = "/health" },
    @{ Name = "alive"; Path = "/alive" },
    @{ Name = "ready"; Path = "/health/ready" },
    @{ Name = "GetMyIp"; Path = "/api/v1/IpLookup/GetMyIp" }
)

Write-Host "Waiting up to ${WaitSeconds}s for $WebBaseUrl ..." -ForegroundColor Cyan
$deadline = (Get-Date).AddSeconds($WaitSeconds)
$ready = $false

while ((Get-Date) -lt $deadline) {
    try {
        $probe = Invoke-WebRequest -Uri "$WebBaseUrl/health" -UseBasicParsing -TimeoutSec 3
        if ($probe.StatusCode -eq 200) {
            $ready = $true
            break
        }
    }
    catch {
        Start-Sleep -Seconds 2
    }
}

if (-not $ready) {
    Write-Host "FAIL: Web API did not become healthy at $WebBaseUrl" -ForegroundColor Red
    exit 1
}

$results = @()
foreach ($ep in $endpoints) {
    $url = "$WebBaseUrl$($ep.Path)"
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 15
        $ok = $response.StatusCode -ge 200 -and $response.StatusCode -lt 300
        $results += [pscustomobject]@{
            Name   = $ep.Name
            Url    = $url
            Status = $response.StatusCode
            Ok     = $ok
        }
        $color = if ($ok) { "Green" } else { "Yellow" }
        Write-Host ("OK  [{0}] {1} -> {2}" -f $ep.Name, $url, $response.StatusCode) -ForegroundColor $color
    }
    catch {
        $results += [pscustomobject]@{
            Name   = $ep.Name
            Url    = $url
            Status = "error"
            Ok     = $false
        }
        Write-Host ("FAIL [{0}] {1} -> {2}" -f $ep.Name, $url, $_.Exception.Message) -ForegroundColor Red
    }
}

if ($results | Where-Object { -not $_.Ok }) {
    exit 1
}

Write-Host "All health endpoints passed." -ForegroundColor Green
exit 0
