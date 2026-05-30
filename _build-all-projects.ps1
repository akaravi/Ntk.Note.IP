<#
.SYNOPSIS
  Full IPNote.ir build orchestrator (solution, tests, SPA, optional release package, optional dev stack).

.DESCRIPTION
  Modeled after Karavi.Thesis _build-all-projects.ps1. Reuses build.ps1 and scripts/*.ps1.

  Quick dev (build + tests + i18n, no ZIP, start Aspire):
    .\_build-all-projects.ps1 -SkipPackage

  Release artifact ZIP (outputs under publish/; ZIP file written outside publish/):
    .\_build-all-projects.ps1 -Configuration Release

  Publish layout (repo root):
    publish/dotnet/web         Web API Release
    publish/dotnet/web-debug   Web API Debug
    publish/flutter/android    Android APK/AAB
    publish/flutter/web        Flutter web

  Default ZIP output: D:\PublishKaravi\IPNote.ir (override with -ZipOutputDirectory)

  APK only (no Play Store bundle):
    .\_build-all-projects.ps1 -Configuration Release -PackageOnly -AndroidArtifact apk

  Build only (no dev servers):
    .\_build-all-projects.ps1 -SkipPackage -SkipDevServers

  Package ZIP only (no AppHost):
    .\_build-all-projects.ps1 -Configuration Release -PackageOnly
#>
param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Debug",

    [switch]$SkipRestore,
    [switch]$SkipStopRunningProjects,
    [switch]$SkipTests,
    [switch]$Coverage,

    [switch]$SkipPackage,
    [string]$ZipOutputDirectory = "",
    [switch]$PackageOnly,
    [switch]$NonInteractive,

    [switch]$SkipFlutter,
    [switch]$SkipFlutterAnalyze,
    [switch]$SkipFlutterAndroid,
    [switch]$SkipFlutterWeb,
    [ValidateSet("apk", "appbundle", "all")]
    [string]$AndroidArtifact = "all",
    [string]$ApiBaseUrl = "https://ipnote.ir",

    [switch]$SkipSpa,
    [switch]$SkipDevServers,
    [switch]$UseRedisContainer,

    [switch]$OfflinePubGet,
    [switch]$UseFlutterIoCnMirror,
    [string]$PubHostedUrl = "",
    [string]$FlutterStorageBaseUrl = ""
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$solutionPath = Join-Path $root "Ntk.Note.IP.sln"
$webProj = Join-Path $root "src\Web\Web.csproj"
$appHostProj = Join-Path $root "src\AppHost\AppHost.csproj"
$flutterAppPath = Join-Path $root "src\Mobile\ntk_note_ip_app"
$publishRoot = Join-Path $root "publish"
$publishWebDir = Join-Path $publishRoot "dotnet\web"
$publishWebDebugDir = Join-Path $publishRoot "dotnet\web-debug"
$androidPublishDir = Join-Path $publishRoot "flutter\android"
$flutterWebPublishDir = Join-Path $publishRoot "flutter\web"
$zipStagingDir = Join-Path $root "artifacts\zip-staging"
$defaultZipOutputDir = "D:\PublishKaravi\IPNote.ir"

Set-Location $root

function Assert-PathExists {
    param(
        [Parameter(Mandatory = $true)][string]$PathToCheck,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if (-not (Test-Path -LiteralPath $PathToCheck)) {
        throw "$Label was not found: $PathToCheck"
    }
}

function Resolve-CommandPath {
    param(
        [Parameter(Mandatory = $true)][string]$CommandName,
        [string[]]$CandidatePaths = @()
    )

    $cmd = Get-Command $CommandName -ErrorAction SilentlyContinue
    if ($cmd) {
        return $cmd.Source
    }

    foreach ($candidate in $CandidatePaths) {
        if ([string]::IsNullOrWhiteSpace($candidate)) { continue }
        $expanded = [Environment]::ExpandEnvironmentVariables($candidate)
        if (Test-Path -LiteralPath $expanded) {
            return $expanded
        }
    }

    return $null
}

function Stop-IpNoteRunningProcesses {
    $names = @(
        "Ntk.Note.IP.AppHost",
        "Ntk.Note.IP.Web"
    )

    foreach ($name in $names) {
        $running = Get-Process -Name $name -ErrorAction SilentlyContinue
        if (-not $running) { continue }

        foreach ($proc in $running) {
            try {
                Stop-Process -Id $proc.Id -Force -ErrorAction Stop
                Write-Host "Stopped: $name (PID $($proc.Id))" -ForegroundColor DarkYellow
            }
            catch {
                Write-Warning "Could not stop $name (PID $($proc.Id)): $($_.Exception.Message)"
            }
        }
    }

    Get-Process -Name "dotnet" -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -like "*Ntk.Note.IP*" } |
        ForEach-Object {
            try {
                Stop-Process -Id $_.Id -Force -ErrorAction Stop
                Write-Host "Stopped dotnet child (PID $($_.Id))" -ForegroundColor DarkYellow
            }
            catch {
                Write-Warning "Could not stop dotnet PID $($_.Id): $($_.Exception.Message)"
            }
        }

    Start-Sleep -Seconds 1
}

function Resolve-ExistingOrNewDirectory {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return (New-Item -ItemType Directory -Path $Path -Force).FullName
    }

    return (Resolve-Path -LiteralPath $Path).Path
}

function Set-FlutterMirrorEnvironment {
    if ($UseFlutterIoCnMirror) {
        if ([string]::IsNullOrWhiteSpace($PubHostedUrl)) {
            $script:PubHostedUrl = "https://pub.flutter-io.cn"
        }
        if ([string]::IsNullOrWhiteSpace($FlutterStorageBaseUrl)) {
            $script:FlutterStorageBaseUrl = "https://storage.flutter-io.cn"
        }
        Write-Host "Flutter mirror: flutter-io.cn" -ForegroundColor DarkCyan
    }

    if (-not [string]::IsNullOrWhiteSpace($PubHostedUrl)) {
        $env:PUB_HOSTED_URL = $PubHostedUrl
    }
    if (-not [string]::IsNullOrWhiteSpace($FlutterStorageBaseUrl)) {
        $env:FLUTTER_STORAGE_BASE_URL = $FlutterStorageBaseUrl
    }
}

function Invoke-DotNetRestore {
    Write-Host "dotnet restore ($Configuration) ..." -ForegroundColor Cyan
    dotnet restore $solutionPath
    if ($LASTEXITCODE -ne 0) { throw "dotnet restore failed" }
}

function Invoke-CoreBuildAndTest {
    Write-Host "=== Core .NET build + tests (build.ps1) ===" -ForegroundColor Cyan
    & (Join-Path $root "build.ps1") `
        -Configuration $Configuration `
        -SkipRestore `
        -SkipStopRunningProjects:($SkipStopRunningProjects) `
        -SkipTests:$SkipTests `
        -Coverage:$Coverage
    if ($LASTEXITCODE -ne 0) { throw "build.ps1 failed" }
}

function Invoke-SpaPublish {
    if ($SkipSpa) {
        Write-Host "SKIP Angular SPA -> wwwroot (-SkipSpa)" -ForegroundColor DarkYellow
        return
    }

    Write-Host "=== Angular SPA -> wwwroot ===" -ForegroundColor Cyan
    & (Join-Path $root "scripts\build-spa-to-wwwroot.ps1")
    if ($LASTEXITCODE -ne 0) { throw "build-spa-to-wwwroot.ps1 failed" }
}

function Invoke-WebPublish {
    Write-Host "=== Publish Web API ($Configuration) ===" -ForegroundColor Cyan
    & (Join-Path $root "scripts\publish-api.ps1") -Configuration $Configuration -OutputPath $publishWebDir
    if ($LASTEXITCODE -ne 0) { throw "publish-api.ps1 failed" }
}

function Invoke-FlutterCi {
    if ($SkipFlutter) {
        Write-Host "SKIP Flutter CI (-SkipFlutter)" -ForegroundColor DarkYellow
        return
    }

    Set-FlutterMirrorEnvironment

    if ($SkipFlutterAnalyze) {
        Write-Host "Flutter: pub get + test only (-SkipFlutterAnalyze)" -ForegroundColor Cyan
        $flutter = Resolve-CommandPath -CommandName "flutter"
        if (-not $flutter) { throw "Flutter SDK not found on PATH." }

        Push-Location $flutterAppPath
        try {
            $pubScript = Join-Path $root "scripts\flutter-pub-get.ps1"
            if ($OfflinePubGet) {
                & $pubScript -Offline
            }
            else {
                & $pubScript
            }
            if ($LASTEXITCODE -ne 0) { throw "flutter pub get failed" }

            if (-not $SkipTests) {
                & $flutter test
                if ($LASTEXITCODE -ne 0) { throw "flutter test failed" }
            }
        }
        finally {
            Pop-Location
        }
        return
    }

    $flutterCiArgs = @()
    if ($OfflinePubGet) {
        # flutter-ci has no OfflinePubGet; env mirror + manual pub get handled above when SkipFlutterAnalyze
    }
    if (-not $SkipRestore) {
        # build.ps1 path already restored .NET; flutter-ci runs pub get
    }
    else {
        $flutterCiArgs += "-SkipPubGet"
    }

    & (Join-Path $root "scripts\flutter-ci.ps1") @flutterCiArgs
    if ($LASTEXITCODE -ne 0) { throw "flutter-ci.ps1 failed" }
}

function Invoke-FlutterAndroidRelease {
    if ($SkipFlutter -or $SkipFlutterAndroid) {
        Write-Host "SKIP Flutter Android release (-SkipFlutter / -SkipFlutterAndroid)" -ForegroundColor DarkYellow
        return
    }

    $target = switch ($AndroidArtifact) {
        "apk" { "apk" }
        "appbundle" { "appbundle" }
        "all" { "all" }
    }

    New-Item -ItemType Directory -Force -Path $androidPublishDir | Out-Null

    Write-Host "=== Flutter Android release ($target) ===" -ForegroundColor Cyan
    & (Join-Path $root "scripts\flutter-release-build.ps1") `
        -Target $target `
        -ApiBaseUrl $ApiBaseUrl `
        -PublishDir $androidPublishDir `
        -SkipCi
    if ($LASTEXITCODE -ne 0) { throw "flutter-release-build.ps1 failed" }

    $published = @(
        Get-ChildItem -Path $androidPublishDir -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Extension -in @(".apk", ".aab") -and $_.Name -match '_\d+\.\d+\.\d+-build\d+' }
    )
    if ($published.Count -gt 0) {
        Write-Host "Android versioned artifacts -> $androidPublishDir" -ForegroundColor Green
        foreach ($artifact in $published) {
            $kind = if ($artifact.Extension -eq ".apk") { "APK" } else { "AAB" }
            $sizeMb = [math]::Round($artifact.Length / 1MB, 2)
            Write-Host "  [$kind] $($artifact.Name) ($sizeMb MB)" -ForegroundColor DarkGreen
        }
    }
    else {
        Write-Warning "No versioned .apk or .aab found under $androidPublishDir"
    }
}

function Invoke-FlutterWebRelease {
    if ($SkipFlutter -or $SkipFlutterWeb) {
        Write-Host "SKIP Flutter web release (-SkipFlutter / -SkipFlutterWeb)" -ForegroundColor DarkYellow
        return
    }

    New-Item -ItemType Directory -Force -Path $flutterWebPublishDir | Out-Null

    Write-Host "=== Flutter web release ===" -ForegroundColor Cyan
    & (Join-Path $root "scripts\flutter-web-build.ps1") `
        -ApiBaseUrl $ApiBaseUrl `
        -SkipCi
    if ($LASTEXITCODE -ne 0) { throw "flutter-web-build.ps1 failed" }

    $webBuildDir = Join-Path $flutterAppPath "build\web"
    if (-not (Test-Path -LiteralPath (Join-Path $webBuildDir "index.html"))) {
        throw "Flutter web build output missing: $webBuildDir\index.html"
    }

    if (Test-Path -LiteralPath $flutterWebPublishDir) {
        Remove-Item -Recurse -Force $flutterWebPublishDir
    }
    New-Item -ItemType Directory -Force -Path $flutterWebPublishDir | Out-Null
    Copy-Item -Recurse -Force (Join-Path $webBuildDir "*") $flutterWebPublishDir

    Write-Host "Flutter web copied -> $flutterWebPublishDir" -ForegroundColor Green
    Write-Host "  [WEB] $(Join-Path $flutterWebPublishDir 'index.html')" -ForegroundColor DarkGreen
}

function Invoke-DeployZip {
    param([Parameter(Mandatory = $true)][string]$ZipDirectory)

    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $resolvedZipDir = Resolve-ExistingOrNewDirectory -Path $ZipDirectory
    $stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $zipName = "IPNote_ir_Build_$stamp.zip"
    $zipFullPath = Join-Path $resolvedZipDir $zipName

    $stageRoot = $zipStagingDir
    if (Test-Path -LiteralPath $stageRoot) {
        Remove-Item -Recurse -Force $stageRoot
    }
    New-Item -ItemType Directory -Path $stageRoot -Force | Out-Null

    Write-Host "Staging deploy ZIP under $stageRoot (publish/ is not used for ZIP staging) ..." -ForegroundColor Cyan

    if (Test-Path -LiteralPath $publishWebDir) {
        Copy-Item -Recurse -Force $publishWebDir (Join-Path $stageRoot "web_publish")
    }
    else {
        throw "Web publish folder missing: $publishWebDir"
    }

    $wwwRoot = Join-Path $root "src\Web\wwwroot"
    if (Test-Path -LiteralPath (Join-Path $wwwRoot "index.html")) {
        Copy-Item -Recurse -Force $wwwRoot (Join-Path $stageRoot "wwwroot_spa")
    }

    if (Test-Path -LiteralPath $androidPublishDir) {
        $androidFiles = @(
            Get-ChildItem -Path $androidPublishDir -File -Filter "*.apk" -ErrorAction SilentlyContinue
            Get-ChildItem -Path $androidPublishDir -File -Filter "*.aab" -ErrorAction SilentlyContinue
        )
        if ($androidFiles.Count -gt 0) {
            $androidStage = Join-Path $stageRoot "mobile_android"
            New-Item -ItemType Directory -Path $androidStage -Force | Out-Null
            foreach ($f in $androidFiles) {
                Copy-Item -Force $f.FullName (Join-Path $androidStage $f.Name)
            }
            $apkCount = @($androidFiles | Where-Object { $_.Extension -eq ".apk" }).Count
            $aabCount = @($androidFiles | Where-Object { $_.Extension -eq ".aab" }).Count
            Write-Host "ZIP mobile_android: $apkCount APK, $aabCount AAB" -ForegroundColor DarkGray
        }
    }

    if (Test-Path -LiteralPath $flutterWebPublishDir) {
        $webIndex = Join-Path $flutterWebPublishDir "index.html"
        if (Test-Path -LiteralPath $webIndex) {
            Copy-Item -Recurse -Force $flutterWebPublishDir (Join-Path $stageRoot "mobile_web")
            Write-Host "ZIP mobile_web: Flutter web (index.html + assets)" -ForegroundColor DarkGray
        }
    }

    if (Test-Path -LiteralPath $zipFullPath) {
        Remove-Item -Force $zipFullPath
    }

    [System.IO.Compression.ZipFile]::CreateFromDirectory(
        $stageRoot,
        $zipFullPath,
        [System.IO.Compression.CompressionLevel]::Optimal,
        $false)

    Remove-Item -Recurse -Force $stageRoot

    Write-Host ""
    Write-Host "Deploy ZIP: $zipFullPath" -ForegroundColor Green
}

function Invoke-DevStack {
    $runAllArgs = @("-SkipBuild")
    if ($SkipFlutter) { $runAllArgs += "-SkipFlutter" }
    if ($UseRedisContainer) { $runAllArgs += "-UseRedisContainer" }

    Write-Host "=== Starting dev stack (run-all.ps1) ===" -ForegroundColor Cyan
    & (Join-Path $root "scripts\run-all.ps1") @runAllArgs
    if ($LASTEXITCODE -ne 0) { throw "run-all.ps1 failed" }
}

Assert-PathExists -PathToCheck $solutionPath -Label "Solution file"
Assert-PathExists -PathToCheck $webProj -Label "Web project"
Assert-PathExists -PathToCheck $appHostProj -Label "AppHost project"

Write-Host ""
Write-Host "=== IPNote.ir _build-all-projects ($Configuration) ===" -ForegroundColor Cyan
Write-Host "Root: $root" -ForegroundColor DarkGray

if (-not $SkipStopRunningProjects) {
    Stop-IpNoteRunningProcesses
}

if (-not $SkipPackage) {
    if ([string]::IsNullOrWhiteSpace($ZipOutputDirectory)) {
        if ($NonInteractive) {
            $ZipOutputDirectory = $defaultZipOutputDir
            Write-Host "Non-interactive ZIP -> $ZipOutputDirectory" -ForegroundColor DarkGray
        }
        else {
            Write-Host "مسیر پوشه برای ZIP خروجی استقرار را وارد کنید (Enter = D:\PublishKaravi\IPNote.ir):" -ForegroundColor Cyan
            $inputPath = Read-Host "ZIP output folder"
            if ([string]::IsNullOrWhiteSpace($inputPath)) {
                $ZipOutputDirectory = $defaultZipOutputDir
            }
            else {
                $ZipOutputDirectory = $inputPath
            }
        }
    }

    if (-not $SkipRestore) {
        Invoke-DotNetRestore
    }

    Invoke-CoreBuildAndTest
    Invoke-SpaPublish
    Invoke-WebPublish
    Invoke-FlutterCi
    Invoke-FlutterAndroidRelease
    Invoke-FlutterWebRelease
    Invoke-DeployZip -ZipDirectory $ZipOutputDirectory
}
else {
    if (-not $SkipRestore) {
        Invoke-DotNetRestore
    }

    Invoke-CoreBuildAndTest
    Invoke-SpaPublish
    Invoke-FlutterCi
}

if ($PackageOnly) {
    Write-Host ""
    Write-Host "Package-only: dev stack was not started (-PackageOnly)." -ForegroundColor Yellow
    Write-Host "Done." -ForegroundColor Green
    exit 0
}

if (-not $SkipDevServers) {
    Invoke-DevStack
}
else {
    Write-Host "SKIP dev stack (-SkipDevServers)." -ForegroundColor DarkYellow
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host "Tips:" -ForegroundColor DarkYellow
Write-Host "  -SkipPackage     daily dev build (default companion to run-all)" -ForegroundColor DarkGray
Write-Host "  -Configuration Release -PackageOnly   release ZIP without AppHost" -ForegroundColor DarkGray
Write-Host "  -SkipStopRunningProjects   skip killing AppHost/Web before build" -ForegroundColor DarkGray
Write-Host "  publish/dotnet/*, publish/flutter/*   all project publish outputs" -ForegroundColor DarkGray
Write-Host "  -ZipOutputDirectory <path>   ZIP destination (default D:\PublishKaravi\IPNote.ir)" -ForegroundColor DarkGray
Write-Host "  -SkipFlutterAndroid   release ZIP without mobile Android artifacts" -ForegroundColor DarkGray
Write-Host "  -SkipFlutterWeb       release ZIP without Flutter web artifacts" -ForegroundColor DarkGray
