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
