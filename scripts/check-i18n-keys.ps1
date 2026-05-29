param(
    [string]$FaPath = "$PSScriptRoot\..\docs\i18n\fa.json",
    [string]$EnPath = "$PSScriptRoot\..\docs\i18n\en.json"
)

function Get-FlatKeys {
    param([object]$Node, [string]$Prefix = "")
    $keys = @()
    if ($Node -is [System.Collections.IDictionary] -or ($Node.PSObject.Properties.Name)) {
        foreach ($prop in $Node.PSObject.Properties) {
            $name = if ($Prefix) { "$Prefix.$($prop.Name)" } else { $prop.Name }
            if ($prop.Value -is [string]) {
                $keys += $name
            }
            else {
                $keys += Get-FlatKeys -Node $prop.Value -Prefix $name
            }
        }
    }
    return $keys
}

$fa = Get-Content $FaPath -Raw -Encoding UTF8 | ConvertFrom-Json
$en = Get-Content $EnPath -Raw -Encoding UTF8 | ConvertFrom-Json

$faKeys = Get-FlatKeys $fa | Sort-Object -Unique
$enKeys = Get-FlatKeys $en | Sort-Object -Unique

$missingInEn = $faKeys | Where-Object { $_ -notin $enKeys }
$missingInFa = $enKeys | Where-Object { $_ -notin $faKeys }

$exitCode = 0
if ($missingInEn.Count -gt 0) {
    Write-Host "Missing in en.json:" -ForegroundColor Yellow
    $missingInEn | ForEach-Object { Write-Host "  $_" }
    $exitCode = 1
}
if ($missingInFa.Count -gt 0) {
    Write-Host "Missing in fa.json:" -ForegroundColor Yellow
    $missingInFa | ForEach-Object { Write-Host "  $_" }
    $exitCode = 1
}
if ($exitCode -eq 0) {
    Write-Host "i18n keys aligned ($($faKeys.Count) keys)." -ForegroundColor Green
}
exit $exitCode
