using Ntk.Note.IP.Shared;

var builder = DistributedApplication.CreateBuilder(args);

builder.AddAzureContainerAppEnvironment("aca-env");

var databaseServer = builder
    .AddSqlite(Services.Database);

var web = builder.AddProject<Projects.Web>(Services.WebApi)
    .WithReference(databaseServer)
    .WaitFor(databaseServer)
    .WithExternalHttpEndpoints()
    .WithAspNetCoreEnvironment()
    .WithUrlForEndpoint("http", url =>
    {
        url.DisplayText = "Scalar API Reference";
        url.Url = "/scalar";
    });

if (string.Equals(
        Environment.GetEnvironmentVariable("IPNOTE_USE_REDIS_CONTAINER"),
        "true",
        StringComparison.OrdinalIgnoreCase))
{
    var redis = builder.AddRedis(Services.Redis);
    web = web.WithReference(redis).WaitFor(redis);
}

if (builder.ExecutionContext.IsRunMode)
{
    builder.AddJavaScriptApp(Services.WebFrontend, "./../Web/ClientApp")
        .WithRunScript("start")
        .WithReference(web)
        .WaitFor(web)
        .WithHttpEndpoint(port: 5342, env: "PORT", name: "spa-http", isProxied: false);
}

builder.Build().Run();
