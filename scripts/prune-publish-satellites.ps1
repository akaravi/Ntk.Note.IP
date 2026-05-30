param(
    [Parameter(Mandatory = $true)]
    [string]$PublishDir
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $PublishDir)) {
    Write-Warning "Publish directory not found: $PublishDir"
    exit 0
}

$keepRoots = @(
    "wwwroot",
    "runtimes",
    "en",
    "en-US",
    "refs"
)

$removed = @()
foreach ($dir in Get-ChildItem -LiteralPath $PublishDir -Directory -ErrorAction SilentlyContinue) {
    if ($dir.Name -in $keepRoots) {
        continue
    }

    # ISO culture folders from NuGet satellite assemblies (Hangfire, EF, Identity, …).
    if ($dir.Name -match '^[a-z]{2}(-[A-Z]{2})?$') {
        Remove-Item -LiteralPath $dir.FullName -Recurse -Force
        $removed += $dir.Name
    }
}

if ($removed.Count -gt 0) {
    Write-Host "Removed satellite culture folders: $($removed -join ', ')" -ForegroundColor DarkCyan
}
else {
    Write-Host "No extra satellite culture folders to remove." -ForegroundColor DarkGray
}
