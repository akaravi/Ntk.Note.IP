param(
    [switch]$IncludePublishOutput
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent

$blockedPatterns = @(
    'fonts\.googleapis\.com',
    'fonts\.gstatic\.com',
    'www\.gstatic\.com/flutter',
    'cdn\.jsdelivr\.net',
    'unpkg\.com',
    'cdnjs\.cloudflare\.com',
    'stackpath\.bootstrapcdn\.com',
    'ajax\.googleapis\.com',
    'maxcdn\.bootstrapcdn\.com',
    'package:google_fonts',
    'google_fonts:'
)

$scanRoots = @(
    (Join-Path $root "src\Web\ClientApp\src"),
    (Join-Path $root "src\Web\ClientApp\src\index.html"),
    (Join-Path $root "src\Web\ClientApp-React"),
    (Join-Path $root "src\Mobile\ntk_note_ip_app\lib"),
    (Join-Path $root "src\Mobile\ntk_note_ip_app\pubspec.yaml"),
    (Join-Path $root "src\Mobile\ntk_note_ip_app\web"),
    (Join-Path $root "scripts\flutter-web-build.ps1")
)

if ($IncludePublishOutput) {
    $scanRoots += @(
        (Join-Path $root "src\Web\wwwroot")
    )
}

$extensions = @('.html', '.htm', '.scss', '.css', '.js', '.jsx', '.tsx', '.ts', '.dart', '.ps1', '.mdc')
$excludeDirNames = @('node_modules', '.git', 'dist', 'build', 'canvaskit', '.dart_tool', 'packages')

$violations = @()

function Test-PathExcluded {
    param([string]$Path)
    foreach ($part in $excludeDirNames) {
        if ($Path -match "[\\/]$([regex]::Escape($part))([\\/]|$)") {
            return $true
        }
    }
    return $false
}

foreach ($scanRoot in $scanRoots) {
    if (-not (Test-Path -LiteralPath $scanRoot)) { continue }

    $files = if (Test-Path -LiteralPath $scanRoot -PathType Leaf) {
        @(Get-Item -LiteralPath $scanRoot)
    }
    else {
        Get-ChildItem -Path $scanRoot -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object {
                $extensions -contains $_.Extension.ToLowerInvariant() -and
                -not (Test-PathExcluded $_.FullName)
            }
    }

    foreach ($file in $files) {
        $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
        if ([string]::IsNullOrEmpty($content)) { continue }

        foreach ($pattern in $blockedPatterns) {
            if ($content -match $pattern) {
                $violations += [pscustomobject]@{
                    File = $file.FullName.Substring($root.Length).TrimStart('\', '/')
                    Pattern = $pattern
                }
            }
        }
    }
}

# Flutter web build must pin local CanvasKit.
$flutterWebScript = Join-Path $root "scripts\flutter-web-build.ps1"
if (Test-Path -LiteralPath $flutterWebScript) {
    $scriptText = Get-Content -LiteralPath $flutterWebScript -Raw
    if ($scriptText -notmatch '--no-web-resources-cdn') {
        $violations += [pscustomobject]@{
            File = 'scripts/flutter-web-build.ps1'
            Pattern = 'missing --no-web-resources-cdn'
        }
    }
}

# Scan compiled web output: require local CanvasKit, ignore dormant URL strings in JS.
function Test-FlutterWebPublishOutput {
    param([string]$PublishWebDir)

    if (-not (Test-Path -LiteralPath $PublishWebDir)) { return @() }

    $issues = @()
    $bootstrap = Join-Path $PublishWebDir "flutter_bootstrap.js"
    if (Test-Path -LiteralPath $bootstrap) {
        $text = Get-Content -LiteralPath $bootstrap -Raw
        if ($text -notmatch 'useLocalCanvasKit"\s*:\s*true') {
            $issues += [pscustomobject]@{
                File = 'publish/flutter/web/flutter_bootstrap.js'
                Pattern = 'useLocalCanvasKit not true (rebuild with --no-web-resources-cdn)'
            }
        }
    }

    return $issues
}

if ($IncludePublishOutput) {
    $violations += Test-FlutterWebPublishOutput -PublishWebDir (Join-Path $root "publish\flutter\web")
}

if ($violations.Count -gt 0) {
    Write-Host "External CDN violations found:" -ForegroundColor Red
    foreach ($v in $violations) {
        Write-Host "  $($v.File) -> $($v.Pattern)" -ForegroundColor Yellow
    }
    exit 1
}

Write-Host "No external CDN references in scanned sources." -ForegroundColor Green
