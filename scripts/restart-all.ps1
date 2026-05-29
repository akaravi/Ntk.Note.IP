param(
    [switch]$UseRedisContainer,
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent

& "$PSScriptRoot\run-all.ps1" @PSBoundParameters -Restart
