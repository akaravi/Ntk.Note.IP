param(
    [ValidateSet('appbundle', 'apk', 'all')]
    [string]$Target = 'appbundle',

    [string]$ApiBaseUrl = 'https://ipnote.ir',

    [string]$PublishDir = "",

    [switch]$SkipCi
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$appDir = Join-Path $root "src\Mobile\ntk_note_ip_app"
$keyProps = Join-Path $appDir "android\key.properties"
$symbolsDir = Join-Path $appDir "build\app\outputs\symbols"

. (Join-Path $PSScriptRoot "flutter-android-publish.ps1")

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter SDK not found on PATH."
}

if (-not $SkipCi) {
    & "$root\scripts\flutter-ci.ps1"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

function Clear-AndroidReleaseCaches {
    param([Parameter(Mandatory = $true)][string]$FlutterAppDir)

    Write-Host "Clearing Android/Kotlin build caches (cross-drive incremental fix)..." -ForegroundColor DarkCyan
    $buildDir = Join-Path $FlutterAppDir "build"
    if (Test-Path -LiteralPath $buildDir) {
        Remove-Item -LiteralPath $buildDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    $androidDir = Join-Path $FlutterAppDir "android"
    if (Test-Path -LiteralPath $androidDir) {
        Push-Location $androidDir
        try {
            if (Test-Path -LiteralPath ".\gradlew.bat") {
                & .\gradlew.bat --stop 2>$null | Out-Null
            }
        }
        finally {
            Pop-Location
        }
    }
}

Set-Location $appDir
& "$root\scripts\flutter-pub-get.ps1"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Clear-AndroidReleaseCaches -FlutterAppDir $appDir

$versionLabel = Get-FlutterPubspecVersionLabel -FlutterAppDir $appDir
$defineArgs = @('--dart-define=API_BASE_URL=' + $ApiBaseUrl)
$sizeArgs = @(
    '--obfuscate',
    "--split-debug-info=$symbolsDir",
    '--tree-shake-icons',
    '--target-platform=android-arm,android-arm64'
)

Write-Host "=== IPNote.ir Flutter release build ===" -ForegroundColor Cyan
Write-Host "API_BASE_URL=$ApiBaseUrl" -ForegroundColor DarkGray
Write-Host "Version label: $versionLabel" -ForegroundColor DarkGray

if (Test-Path $keyProps) {
    Write-Host "Android: release signing via android/key.properties" -ForegroundColor Green
}
else {
    Write-Host "WARN: android/key.properties missing - Android release uses debug signing." -ForegroundColor Yellow
    Write-Host "      Copy android/key.properties.example and add upload keystore." -ForegroundColor DarkGray
}

function Invoke-FlutterBuild {
    param([string[]]$FlutterArgs)

    & flutter @FlutterArgs
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

if ($Target -eq 'appbundle' -or $Target -eq 'all') {
    Invoke-FlutterBuild -FlutterArgs (@('build', 'appbundle', '--release') + $sizeArgs + $defineArgs)
}

if ($Target -eq 'apk' -or $Target -eq 'all') {
    # Per-ABI APKs are much smaller than a universal fat APK.
    Invoke-FlutterBuild -FlutterArgs (@('build', 'apk', '--release', '--split-per-abi') + $sizeArgs + $defineArgs)
}

if ([string]::IsNullOrWhiteSpace($PublishDir)) {
    $PublishDir = Join-Path $root "publish\flutter\android"
}

$published = Publish-FlutterAndroidArtifacts `
    -FlutterAppDir $appDir `
    -DestinationDir $PublishDir `
    -VersionLabel $versionLabel

if ($published.Count -gt 0) {
    Write-Host ""
    Write-Host "Versioned Android artifacts:" -ForegroundColor Cyan
    foreach ($artifact in $published) {
        $sizeMb = [math]::Round($artifact.Length / 1MB, 2)
        $kind = if ($artifact.Extension -eq ".apk") { "APK" } else { "AAB" }
        Write-Host "  [$kind] $($artifact.Name) ($sizeMb MB)" -ForegroundColor Green
        Write-Host "         $($artifact.FullName)" -ForegroundColor DarkGreen
    }
}
else {
    Write-Warning "No release APK/AAB artifacts were published."
}

Write-Host ""
Write-Host "Next: upload AAB to Play Console internal track; sideload arm64-v8a APK for smallest install." -ForegroundColor DarkGray
Write-Host "See docs/mobile/store-release-checklist.md" -ForegroundColor DarkGray
