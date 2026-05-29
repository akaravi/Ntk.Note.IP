param(
    [Parameter(Mandatory = $true)]
    [object[]]$ExecutionResults,
    [string]$WebBaseUrl = '',
    [string]$OutputPath = '',
    [string]$CommandName = 'run-all.ps1',
    [int]$AppHostPid = 0,
    [string]$LogFile = '',
    [string]$LogErrFile = '',
    [ValidateSet('OK', 'FAIL', 'PARTIAL', 'RUNNING')]
    [string]$OverallStatus = 'OK'
)

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\local-dev-ports.ps1"

$root = Split-Path $PSScriptRoot -Parent
if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $root 'LastRunInfo.html'
}

function ConvertTo-HtmlEncoded {
    param([string]$Text)
    if ($null -eq $Text) { return '' }
    [System.Net.WebUtility]::HtmlEncode([string]$Text)
}

function Get-StatusBadgeClass {
    param([string]$Status)
    switch -Regex ($Status) {
        '^(OK|PASS|SUCCESS)$' { return 'badge--ok' }
        '^(SKIP|SKIPPED)$' { return 'badge--skip' }
        '^(WARN|WARNING)$' { return 'badge--warn' }
        default { return 'badge--fail' }
    }
}

$generatedAt = Get-Date -Format 'yyyy-MM-dd HH:mm:ss K'
$portRows = @(Get-IpNotePortAllocationRows)
$serviceRows = @(Get-IpNoteDevServiceUrlRows -WebBaseUrl $WebBaseUrl -LogFile $LogFile -LogErrFile $LogErrFile -AppHostPid $AppHostPid)

$overallClass = switch ($OverallStatus) {
    'OK' { 'overall--ok' }
    'RUNNING' { 'overall--pending' }
    'PARTIAL' { 'overall--warn' }
    default { 'overall--bad' }
}

$overallLabel = switch ($OverallStatus) {
    'OK' { 'موفق — اجرا کامل شد' }
    'RUNNING' { 'در حال اجرا — AppHost در پس‌زمینه فعال است' }
    'PARTIAL' { 'ناقص — برخی مراحل رد یا با هشدار تمام شد' }
    default { 'ناموفق — اجرا با خطا متوقف شد' }
}

$execRowsHtml = ($ExecutionResults | ForEach-Object {
    $step = ConvertTo-HtmlEncoded $_.Step
    $status = ConvertTo-HtmlEncoded $_.Status
    $detail = ConvertTo-HtmlEncoded $_.Detail
    $badgeClass = Get-StatusBadgeClass $_.Status
    @"
        <tr>
          <td>$step</td>
          <td><span class="badge $badgeClass">$status</span></td>
          <td class="muted">$detail</td>
        </tr>
"@
}) -join "`n"

$portRowsHtml = ($portRows | ForEach-Object {
    $service = ConvertTo-HtmlEncoded $_.Service
    $port = ConvertTo-HtmlEncoded ([string]$_.Port)
    $key = ConvertTo-HtmlEncoded $_.Key
    @"
        <tr>
          <td>$service</td>
          <td><code>$port</code></td>
          <td class="muted"><code>$key</code></td>
        </tr>
"@
}) -join "`n"

$serviceRowsHtml = ($serviceRows | ForEach-Object {
    $name = ConvertTo-HtmlEncoded $_.Name
    $url = ConvertTo-HtmlEncoded $_.Url
    $note = ConvertTo-HtmlEncoded $_.Note
    $isHttp = $_.Url -match '^https?://'
    $urlCell = if ($isHttp) {
        "<a href=`"$url`" target=`"_blank`" rel=`"noopener noreferrer`">$url</a>"
    }
    else {
        "<code>$url</code>"
    }
    @"
        <tr>
          <td>$name</td>
          <td>$urlCell</td>
          <td class="muted">$note</td>
        </tr>
"@
}) -join "`n"

$html = @"
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Last Run Info — IPNote.ir</title>
  <style>
    :root {
      color-scheme: light dark;
      --bg: #f8fafc;
      --surface: #ffffff;
      --text: #0f172a;
      --muted: #64748b;
      --border: #e2e8f0;
      --link: #2563eb;
      --ok: #15803d;
      --ok-bg: #dcfce7;
      --bad: #b91c1c;
      --bad-bg: #fee2e2;
      --warn: #a16207;
      --warn-bg: #fef9c3;
      --skip: #475569;
      --skip-bg: #f1f5f9;
      --pending: #a16207;
      --pending-bg: #fef9c3;
    }
    @media (prefers-color-scheme: dark) {
      :root {
        --bg: #0f172a;
        --surface: #1e293b;
        --text: #f1f5f9;
        --muted: #94a3b8;
        --border: #334155;
        --link: #93c5fd;
        --ok: #4ade80;
        --ok-bg: #14532d;
        --bad: #fca5a5;
        --bad-bg: #7f1d1d;
        --warn: #facc15;
        --warn-bg: #713f12;
        --skip: #cbd5e1;
        --skip-bg: #334155;
        --pending: #facc15;
        --pending-bg: #713f12;
      }
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      font-family: "Segoe UI", Tahoma, system-ui, sans-serif;
      background: var(--bg);
      color: var(--text);
      line-height: 1.5;
      padding: 2rem 1rem;
    }
    .wrap { max-width: 56rem; margin: 0 auto; }
    h1 { font-size: 1.5rem; margin: 0 0 0.25rem; }
    h2 { font-size: 1.1rem; margin: 2rem 0 0.75rem; }
    .sub { color: var(--muted); font-size: 0.9rem; margin-bottom: 1.5rem; }
    a { color: var(--link); word-break: break-all; }
    code { font-size: 0.85em; background: var(--skip-bg); padding: 0.1rem 0.35rem; border-radius: 0.25rem; }
    .overall {
      padding: 1rem 1.25rem;
      border-radius: 0.5rem;
      border: 1px solid var(--border);
      background: var(--surface);
      margin-bottom: 1rem;
      font-weight: 600;
    }
    .overall--ok { border-color: var(--ok); background: var(--ok-bg); color: var(--ok); }
    .overall--bad { border-color: var(--bad); background: var(--bad-bg); color: var(--bad); }
    .overall--warn { border-color: var(--warn); background: var(--warn-bg); color: var(--warn); }
    .overall--pending { border-color: var(--pending); background: var(--pending-bg); color: var(--pending); }
    .table-wrap {
      overflow-x: auto;
      border: 1px solid var(--border);
      border-radius: 0.5rem;
      background: var(--surface);
    }
    table { width: 100%; border-collapse: collapse; font-size: 0.92rem; }
    th, td { padding: 0.65rem 0.85rem; text-align: right; border-bottom: 1px solid var(--border); vertical-align: top; }
    th { background: var(--skip-bg); font-weight: 600; white-space: nowrap; }
    tr:last-child td { border-bottom: none; }
    .muted { color: var(--muted); font-size: 0.88rem; }
    .badge {
      display: inline-block;
      font-size: 0.75rem;
      font-weight: 600;
      padding: 0.15rem 0.55rem;
      border-radius: 999px;
      white-space: nowrap;
    }
    .badge--ok { background: var(--ok-bg); color: var(--ok); }
    .badge--fail { background: var(--bad-bg); color: var(--bad); }
    .badge--warn { background: var(--warn-bg); color: var(--warn); }
    .badge--skip { background: var(--skip-bg); color: var(--skip); }
    @media (max-width: 640px) {
      body { padding: 1rem 0.5rem; }
      th, td { padding: 0.5rem; }
    }
  </style>
</head>
<body>
  <div class="wrap">
    <h1>LastRunInfo — IPNote.ir</h1>
    <p class="sub">آخرین اجرای <code>$(ConvertTo-HtmlEncoded $CommandName)</code> — $generatedAt</p>
    <div class="overall $overallClass">$overallLabel</div>

    <h2>نتیجه اجرا</h2>
    <div class="table-wrap">
      <table>
        <thead>
          <tr><th>مرحله</th><th>وضعیت</th><th>جزئیات</th></tr>
        </thead>
        <tbody>
$execRowsHtml
        </tbody>
      </table>
    </div>

    <h2>آدرس‌های سرویس</h2>
    <div class="table-wrap">
      <table>
        <thead>
          <tr><th>سرویس</th><th>آدرس</th><th>توضیح</th></tr>
        </thead>
        <tbody>
$serviceRowsHtml
        </tbody>
      </table>
    </div>

    <h2>تخصیص پورت‌ها</h2>
    <div class="table-wrap">
      <table>
        <thead>
          <tr><th>سرویس</th><th>پورت</th><th>کلید</th></tr>
        </thead>
        <tbody>
$portRowsHtml
        </tbody>
      </table>
    </div>
  </div>
</body>
</html>
"@

[System.IO.File]::WriteAllText($OutputPath, $html, [System.Text.UTF8Encoding]::new($false))
Write-Host "LastRunInfo written: $OutputPath" -ForegroundColor Green
