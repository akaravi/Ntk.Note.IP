param(
    [Parameter(Mandatory = $true)]
    [string]$AndroidReleaseSha256,

    [Parameter(Mandatory = $true)]
    [string]$AppleTeamId
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent

$sha = $AndroidReleaseSha256.Trim().ToUpperInvariant() -replace ':', ''
if ($sha.Length -ne 64 -or $sha -match '[^0-9A-F]') {
    Write-Error "AndroidReleaseSha256 must be 64 hex chars (colons optional). Got length $($sha.Length)."
}

$teamId = $AppleTeamId.Trim()
if ($teamId -match 'TEAMID|REPLACE') {
    Write-Error "Provide a real Apple Team ID, not a placeholder."
}

$assetLinksPath = Join-Path $root "src\Web\wwwroot\.well-known\assetlinks.json"
$aasaPath = Join-Path $root "src\Web\wwwroot\.well-known\apple-app-site-association"

$assetLinks = @"
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "ir.ipnote.ntk_note_ip_app",
      "sha256_cert_fingerprints": [
        "$sha"
      ]
    }
  }
]
"@

$aasa = @"
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "$teamId.ir.ipnote.ntkNoteIpApp",
        "paths": [
          "/",
          "/ip-lookup",
          "/ip-lookup/*",
          "/dashboard",
          "/ip-notes",
          "/tools",
          "/login"
        ]
      }
    ]
  }
}
"@

[System.IO.File]::WriteAllText($assetLinksPath, $assetLinks.TrimEnd() + "`n", [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText($aasaPath, $aasa.TrimEnd() + "`n", [System.Text.UTF8Encoding]::new($false))

Write-Host "Updated:" -ForegroundColor Green
Write-Host "  $assetLinksPath"
Write-Host "  $aasaPath"
Write-Host "Run: .\scripts\verify-deep-links-placeholders.ps1 -Strict" -ForegroundColor DarkGray
