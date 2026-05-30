function Get-FlutterPubspecVersionLabel {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FlutterAppDir
    )

    $pubspecPath = Join-Path $FlutterAppDir "pubspec.yaml"
    if (-not (Test-Path -LiteralPath $pubspecPath)) {
        return "unknown"
    }

    foreach ($line in Get-Content -LiteralPath $pubspecPath) {
        if ($line -match '^\s*version:\s*(.+)\s*$') {
            return ($matches[1].Trim() -replace '\+', '-build')
        }
    }

    return "unknown"
}

function Publish-FlutterAndroidArtifacts {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FlutterAppDir,
        [string]$DestinationDir = "",
        [string]$VersionLabel = ""
    )

    if ([string]::IsNullOrWhiteSpace($VersionLabel)) {
        $VersionLabel = Get-FlutterPubspecVersionLabel -FlutterAppDir $FlutterAppDir
    }

    $outputsRoot = Join-Path $FlutterAppDir "build\app\outputs"
    if (-not (Test-Path -LiteralPath $outputsRoot)) {
        Write-Warning "Android outputs not found: $outputsRoot"
        return @()
    }

    if ([string]::IsNullOrWhiteSpace($DestinationDir)) {
        $DestinationDir = Join-Path $FlutterAppDir "..\..\..\publish\flutter\android"
        $DestinationDir = [System.IO.Path]::GetFullPath($DestinationDir)
    }

    New-Item -ItemType Directory -Force -Path $DestinationDir | Out-Null

    $artifacts = @(
        Get-ChildItem -Path $outputsRoot -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object {
                ($_.Extension -eq ".aab" -and $_.Name -match 'release') -or
                ($_.Extension -eq ".apk" -and $_.Name -match '-release\.apk$')
            }
    )

    # Prefer split APKs over universal fat APK when both exist.
    $splitApks = @($artifacts | Where-Object { $_.Extension -eq ".apk" -and $_.Name -match '-(armeabi-v7a|arm64-v8a|x86_64)-release\.apk$' })
    if ($splitApks.Count -gt 0) {
        $artifacts = @($artifacts | Where-Object { $_.Name -ne "app-release.apk" })
    }

    # Dedupe when Gradle writes the same APK under flutter-apk/ and apk/.
    $artifacts = @(
        $artifacts |
            Group-Object Name |
            ForEach-Object {
                $preferred = @($_.Group | Where-Object { $_.FullName -match '\\flutter-apk\\' })
                if ($preferred.Count -gt 0) { $preferred[0] } else { $_.Group[0] }
            }
    )

    $published = @()
    foreach ($artifact in $artifacts) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($artifact.Name)
        $versionedName = "${baseName}_${VersionLabel}$($artifact.Extension)"
        $destPath = Join-Path $DestinationDir $versionedName
        Copy-Item -LiteralPath $artifact.FullName -Destination $destPath -Force
        $published += Get-Item -LiteralPath $destPath
    }

    return $published
}
