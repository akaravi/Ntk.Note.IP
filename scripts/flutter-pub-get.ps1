param(
    [switch]$Offline
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter SDK not found on PATH."
}

$pubGetArgs = @("pub", "get")
if ($Offline) {
    $pubGetArgs += "--offline"
}

function Invoke-FlutterPubGet {
    param(
        [string]$Label,
        [string]$HostedUrl
    )

    $previousHostedUrl = $env:PUB_HOSTED_URL
    if ([string]::IsNullOrWhiteSpace($HostedUrl)) {
        Remove-Item Env:PUB_HOSTED_URL -ErrorAction SilentlyContinue
    }
    else {
        $env:PUB_HOSTED_URL = $HostedUrl
    }

    Write-Host "flutter pub get ($Label)..." -ForegroundColor DarkCyan
    & flutter @pubGetArgs | Out-Host
    $exitCode = $LASTEXITCODE

    if ([string]::IsNullOrWhiteSpace($previousHostedUrl)) {
        Remove-Item Env:PUB_HOSTED_URL -ErrorAction SilentlyContinue
    }
    else {
        $env:PUB_HOSTED_URL = $previousHostedUrl
    }

    return $exitCode
}

$exitCode = Invoke-FlutterPubGet -Label "pub.dev" -HostedUrl ""
if ($exitCode -eq 0) {
    exit 0
}

if ($Offline) {
    exit $exitCode
}

Write-Host "pub.dev failed (exit $exitCode); retrying via pub.flutter-io.cn mirror..." -ForegroundColor Yellow
$exitCode = Invoke-FlutterPubGet -Label "pub.flutter-io.cn" -HostedUrl "https://pub.flutter-io.cn"
exit $exitCode
