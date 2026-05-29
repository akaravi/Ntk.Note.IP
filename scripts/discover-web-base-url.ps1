param(
    [string[]]$Candidates = @(),
    [string]$LogPath = '',
    [int]$TimeoutSeconds = 90
)

$ErrorActionPreference = 'Continue'
. "$PSScriptRoot\local-dev-ports.ps1"

if ($Candidates.Count -eq 0) {
    $Candidates = @(
        (Get-IpNoteWebBaseUrl),
        (Get-IpNoteWebHttpsUrl)
    )
}

$deadline = (Get-Date).AddSeconds($TimeoutSeconds)
$tryUrls = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)

foreach ($c in $Candidates) {
    if (-not [string]::IsNullOrWhiteSpace($c)) {
        [void]$tryUrls.Add($c.Trim().TrimEnd('/'))
    }
}

if (-not [string]::IsNullOrWhiteSpace($LogPath) -and (Test-Path -LiteralPath $LogPath)) {
    $logText = Get-Content -LiteralPath $LogPath -Raw -ErrorAction SilentlyContinue
    $errPath = "$LogPath.err"
    if (Test-Path -LiteralPath $errPath) {
        $logText += Get-Content -LiteralPath $errPath -Raw -ErrorAction SilentlyContinue
    }
    if ($logText) {
        $matches = [regex]::Matches($logText, 'https?://localhost:\d+', 'IgnoreCase')
        foreach ($m in $matches) {
            [void]$tryUrls.Add($m.Value.TrimEnd('/'))
        }
    }
}

while ((Get-Date) -lt $deadline) {
    foreach ($base in $tryUrls) {
        $healthUrl = "$base/health"
        try {
            $params = @{
                Uri             = $healthUrl
                UseBasicParsing = $true
                TimeoutSec      = 5
            }
            if ($base.StartsWith('https://', [StringComparison]::OrdinalIgnoreCase) -and $PSVersionTable.PSVersion.Major -ge 7) {
                $params['SkipCertificateCheck'] = $true
            }

            $resp = Invoke-WebRequest @params
            if ($resp.StatusCode -eq 200) {
                Write-Output $base
                exit 0
            }
        }
        catch {
            # try next candidate
        }
    }

    Start-Sleep -Seconds 2
}

Write-Error "No healthy Web API found within ${TimeoutSeconds}s (tried: $($tryUrls -join ', '))"
exit 1
