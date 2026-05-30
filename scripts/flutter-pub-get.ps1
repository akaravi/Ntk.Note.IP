param(
    [switch]$Offline
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter SDK not found on PATH."
}

if (-not (Get-Command dart -ErrorAction SilentlyContinue)) {
    Write-Error "Dart SDK not found on PATH."
}

$pubGetArgs = @("pub", "get")
if ($Offline) {
    $pubGetArgs += "--offline"
}

function Set-PubHostedUrl {
    param([string]$HostedUrl)

    if ([string]::IsNullOrWhiteSpace($HostedUrl)) {
        Remove-Item Env:PUB_HOSTED_URL -ErrorAction SilentlyContinue
    }
    else {
        $env:PUB_HOSTED_URL = $HostedUrl
    }
}

function Test-PackageConfigReady {
    Test-Path -LiteralPath (Join-Path (Get-Location) ".dart_tool\package_config.json")
}

function Invoke-PubGetWithTool {
    param(
        [string]$ToolName,
        [string]$Label,
        [string]$HostedUrl
    )

    $previousHostedUrl = $env:PUB_HOSTED_URL
    Set-PubHostedUrl -HostedUrl $HostedUrl

    Write-Host "$ToolName pub get ($Label)..." -ForegroundColor DarkCyan
    & $ToolName @pubGetArgs | Out-Host
    $exitCode = $LASTEXITCODE

    if ([string]::IsNullOrWhiteSpace($previousHostedUrl)) {
        Remove-Item Env:PUB_HOSTED_URL -ErrorAction SilentlyContinue
    }
    else {
        $env:PUB_HOSTED_URL = $previousHostedUrl
    }

    return $exitCode
}

function Invoke-PubGetAttempt {
    param(
        [string]$Label,
        [string]$HostedUrl
    )

    $flutterExit = Invoke-PubGetWithTool -ToolName "flutter" -Label $Label -HostedUrl $HostedUrl
    if ($flutterExit -eq 0) {
        return 0
    }

    if ($Offline) {
        return $flutterExit
    }

    Write-Host "flutter pub get failed (exit $flutterExit); trying dart pub get..." -ForegroundColor Yellow
    $dartExit = Invoke-PubGetWithTool -ToolName "dart" -Label $Label -HostedUrl $HostedUrl
    if ($dartExit -eq 0 -and (Test-PackageConfigReady)) {
        Write-Host "Dependencies resolved via dart pub get." -ForegroundColor Yellow
        Write-Host "For Android/plugin release builds on Windows, enable Developer Mode: start ms-settings:developers" -ForegroundColor DarkYellow
        return 0
    }

    if ($dartExit -ne 0) {
        return $dartExit
    }

    return $flutterExit
}

$exitCode = Invoke-PubGetAttempt -Label "pub.dev" -HostedUrl ""
if ($exitCode -eq 0) {
    exit 0
}

if ($Offline) {
    exit $exitCode
}

Write-Host "pub.dev failed (exit $exitCode); retrying via pub.flutter-io.cn mirror..." -ForegroundColor Yellow
$exitCode = Invoke-PubGetAttempt -Label "pub.flutter-io.cn" -HostedUrl "https://pub.flutter-io.cn"
exit $exitCode
