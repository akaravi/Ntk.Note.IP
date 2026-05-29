param(
    [ValidateSet('appbundle', 'apk', 'ipa', 'all')]
    [string]$Target = 'appbundle',

    [string]$ApiBaseUrl = 'https://api.ipnote.ir',

    [switch]$SkipCi
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$appDir = Join-Path $root "src\Mobile\ntk_note_ip_app"
$keyProps = Join-Path $appDir "android\key.properties"

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
flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Clear-AndroidReleaseCaches -FlutterAppDir $appDir

$defineArgs = @('--dart-define=API_BASE_URL=' + $ApiBaseUrl)
Write-Host "=== IPNote.ir Flutter release build ===" -ForegroundColor Cyan
Write-Host "API_BASE_URL=$ApiBaseUrl" -ForegroundColor DarkGray

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
    Invoke-FlutterBuild -FlutterArgs (@('build', 'appbundle', '--release') + $defineArgs)
}

if ($Target -eq 'apk' -or $Target -eq 'all') {
    Invoke-FlutterBuild -FlutterArgs (@('build', 'apk', '--release') + $defineArgs)
}

if ($Target -eq 'ipa' -or $Target -eq 'all') {
    if ($IsWindows -or $env:OS -match 'Windows') {
        Write-Host "SKIP [ipa] iOS archive requires macOS + Xcode." -ForegroundColor Yellow
    }
    else {
        Invoke-FlutterBuild -FlutterArgs (@('build', 'ipa', '--release') + $defineArgs)
    }
}

$outDir = Join-Path $appDir "build\app\outputs"
if (Test-Path $outDir) {
    Write-Host ""
    Write-Host "Artifacts under:" -ForegroundColor Cyan
    Get-ChildItem -Path $outDir -Recurse -Include *.aab, *.apk -ErrorAction SilentlyContinue |
        ForEach-Object { Write-Host "  $($_.FullName)" -ForegroundColor Green }
}

Write-Host ""
Write-Host "Next: upload AAB to Play Console internal track; verify deep links on device." -ForegroundColor DarkGray
Write-Host "See docs/mobile/store-release-checklist.md" -ForegroundColor DarkGray
