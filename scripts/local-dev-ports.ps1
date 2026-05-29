# IPNote.ir local development port map (5340-5349)
$script:IpNoteDevPorts = [ordered]@{
    WebHttp               = 5340
    WebHttps              = 5341
    SpaHttp               = 5342
    AspireDashboardHttp   = 5343
    AspireDashboardHttps  = 5344
    DashboardOtlpHttp     = 5345
    DashboardResourceHttp = 5346
    DashboardOtlpHttps    = 5347
    DashboardResourceHttps = 5348
    Reserved              = 5349
}

function Get-IpNoteWebBaseUrl {
    "http://localhost:$($script:IpNoteDevPorts.WebHttp)"
}

function Get-IpNoteWebHttpsUrl {
    "https://localhost:$($script:IpNoteDevPorts.WebHttps)"
}

function Get-IpNoteAspireDashboardUrl {
    "http://ntk.note.ip.dev.localhost:$($script:IpNoteDevPorts.AspireDashboardHttp)"
}

function Get-IpNoteFlutterEmulatorApiUrl {
    "http://10.0.2.2:$($script:IpNoteDevPorts.WebHttp)"
}

function Get-IpNotePortAllocationRows {
    $labels = [ordered]@{
        WebHttp                = 'Web API HTTP'
        WebHttps               = 'Web API HTTPS'
        SpaHttp                = 'Angular SPA (ng serve / Aspire PORT)'
        AspireDashboardHttp    = 'Aspire Dashboard HTTP'
        AspireDashboardHttps   = 'Aspire Dashboard HTTPS'
        DashboardOtlpHttp      = 'Aspire OTLP HTTP'
        DashboardResourceHttp  = 'Aspire Resource Service HTTP'
        DashboardOtlpHttps     = 'Aspire OTLP HTTPS'
        DashboardResourceHttps = 'Aspire Resource Service HTTPS'
        Reserved               = 'Reserved'
    }

    foreach ($key in $labels.Keys) {
        if (-not $script:IpNoteDevPorts.Contains($key)) { continue }
        [pscustomobject]@{
            Service = $labels[$key]
            Port    = $script:IpNoteDevPorts[$key]
            Key     = $key
        }
    }
}

function Get-IpNoteDevServiceUrlRows {
    param(
        [string]$WebBaseUrl = '',
        [string]$LogFile = '',
        [string]$LogErrFile = '',
        [int]$AppHostPid = 0
    )

    if ([string]::IsNullOrWhiteSpace($WebBaseUrl)) {
        $WebBaseUrl = Get-IpNoteWebBaseUrl
    }
    $WebBaseUrl = $WebBaseUrl.Trim().TrimEnd('/')

    $rows = [System.Collections.Generic.List[object]]::new()
    $rows.Add([pscustomobject]@{ Name = 'Aspire Dashboard'; Url = (Get-IpNoteAspireDashboardUrl); Note = 'Dev orchestration UI' })
    $rows.Add([pscustomobject]@{ Name = 'Web API'; Url = $WebBaseUrl; Note = 'REST + SPA host' })
    $rows.Add([pscustomobject]@{ Name = 'Health'; Url = "$WebBaseUrl/health"; Note = 'Liveness probe' })
    $rows.Add([pscustomobject]@{ Name = 'Scalar OpenAPI'; Url = "$WebBaseUrl/scalar"; Note = 'API docs' })
    $rows.Add([pscustomobject]@{ Name = 'Status page'; Url = "$WebBaseUrl/status.html"; Note = 'Runtime health UI' })
    $rows.Add([pscustomobject]@{ Name = 'Changelog'; Url = "$WebBaseUrl/changelog.html"; Note = 'Release notes' })
    $rows.Add([pscustomobject]@{ Name = 'App Links'; Url = "$WebBaseUrl/.well-known/assetlinks.json"; Note = 'Android deep links' })
    $rows.Add([pscustomobject]@{ Name = 'Hangfire (dev)'; Url = "$WebBaseUrl/hangfire"; Note = 'Background jobs dashboard' })
    $rows.Add([pscustomobject]@{ Name = 'Angular SPA (Aspire)'; Url = "http://localhost:$($script:IpNoteDevPorts.SpaHttp)"; Note = 'Separate dev server when using ng serve' })
    $rows.Add([pscustomobject]@{ Name = 'Flutter emulator API'; Url = (Get-IpNoteFlutterEmulatorApiUrl); Note = 'dart-define API_BASE_URL' })

    if ($AppHostPid -gt 0) {
        $rows.Add([pscustomobject]@{ Name = 'AppHost PID'; Url = "$AppHostPid"; Note = 'Background dotnet process' })
    }
    if (-not [string]::IsNullOrWhiteSpace($LogFile)) {
        $rows.Add([pscustomobject]@{ Name = 'AppHost log'; Url = $LogFile; Note = 'stdout log file path' })
    }
    if (-not [string]::IsNullOrWhiteSpace($LogErrFile)) {
        $rows.Add([pscustomobject]@{ Name = 'AppHost log (stderr)'; Url = $LogErrFile; Note = 'stderr log file path' })
    }

    return $rows
}
