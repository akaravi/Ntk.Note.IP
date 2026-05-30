param(
    [string]$MasterIcon = ''
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent

if ([string]::IsNullOrWhiteSpace($MasterIcon)) {
    $MasterIcon = Join-Path $root 'assets\brand\app_icon.png'
}

if (-not (Test-Path -LiteralPath $MasterIcon)) {
    Write-Error "Master icon not found: $MasterIcon"
}

Add-Type -AssemblyName System.Drawing

function Save-PngResize {
    param(
        [string]$SourcePath,
        [string]$DestinationPath,
        [int]$Size
    )

    $destDir = Split-Path $DestinationPath -Parent
    if ($destDir -and -not (Test-Path -LiteralPath $destDir)) {
        New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    }

    $source = [System.Drawing.Image]::FromFile($SourcePath)
    try {
        $bitmap = New-Object System.Drawing.Bitmap $Size, $Size
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        try {
            $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
            $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
            $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
            $graphics.Clear([System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            $graphics.DrawImage($source, 0, 0, $Size, $Size)
        }
        finally {
            $graphics.Dispose()
        }

        $bitmap.Save($DestinationPath, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    finally {
        $source.Dispose()
        if ($bitmap) { $bitmap.Dispose() }
    }
}

function Save-IcoFromPng {
    param(
        [string]$SourcePath,
        [string]$DestinationPath
    )

    $destDir = Split-Path $DestinationPath -Parent
    if ($destDir -and -not (Test-Path -LiteralPath $destDir)) {
        New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    }

    $magick = Get-Command magick -ErrorAction SilentlyContinue
    if ($magick) {
        & magick convert $SourcePath -define icon:auto-resize=16,32,48,64,128,256 $DestinationPath
        return
    }

    $tempPng = Join-Path ([System.IO.Path]::GetTempPath()) "ipnote-favicon-32.png"
    Save-PngResize -SourcePath $SourcePath -DestinationPath $tempPng -Size 32
    try {
        Add-Type @"
using System;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
public static class IpNoteIconWriter {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern bool DestroyIcon(IntPtr handle);
    public static void WriteIco(string pngPath, string icoPath) {
        using var bmp = new Bitmap(pngPath);
        IntPtr hIcon = bmp.GetHicon();
        try {
            using var icon = Icon.FromHandle(hIcon);
            using var fs = File.Create(icoPath);
            icon.Save(fs);
        } finally {
            DestroyIcon(hIcon);
        }
    }
}
"@ -ErrorAction SilentlyContinue | Out-Null
        [IpNoteIconWriter]::WriteIco($tempPng, $DestinationPath)
    }
    finally {
        Remove-Item -LiteralPath $tempPng -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "=== Sync brand icons from $MasterIcon ===" -ForegroundColor Cyan

# Angular SPA
$angularRoot = Join-Path $root 'src\Web\ClientApp\src'
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $angularRoot 'favicon.png') -Size 32
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $angularRoot 'apple-touch-icon.png') -Size 180
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $angularRoot 'assets\icons\icon-192.png') -Size 192
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $angularRoot 'assets\icons\icon-512.png') -Size 512

# React SPA (legacy) — PNG favicons; .ico optional when ImageMagick is installed
$reactPublic = Join-Path $root 'src\Web\ClientApp-React\public'
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $reactPublic 'favicon.png') -Size 32
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $reactPublic 'apple-touch-icon.png') -Size 180
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $reactPublic 'icon-192.png') -Size 192
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $reactPublic 'icon-512.png') -Size 512
$magick = Get-Command magick -ErrorAction SilentlyContinue
if ($magick) {
    Save-IcoFromPng -SourcePath $MasterIcon -DestinationPath (Join-Path $reactPublic 'favicon.ico')
}

# ASP.NET wwwroot static pages
$wwwRoot = Join-Path $root 'src\Web\wwwroot'
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $wwwRoot 'favicon.png') -Size 32

# Flutter web PWA
$flutterWeb = Join-Path $root 'src\Mobile\ntk_note_ip_app\web'
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $flutterWeb 'favicon.png') -Size 32
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $flutterWeb 'icons\Icon-192.png') -Size 192
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $flutterWeb 'icons\Icon-512.png') -Size 512
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $flutterWeb 'icons\Icon-maskable-192.png') -Size 192
Save-PngResize -SourcePath $MasterIcon -DestinationPath (Join-Path $flutterWeb 'icons\Icon-maskable-512.png') -Size 512

Write-Host "Web icons synced." -ForegroundColor Green
