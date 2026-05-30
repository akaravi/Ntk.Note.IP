using Hangfire;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.AspNetCore.Rewrite;
using Ntk.Note.IP.Application.Common.Options;
using Ntk.Note.IP.Infrastructure.Data;
using Ntk.Note.IP.Shared;
using Ntk.Note.IP.Web.Endpoints;
using Ntk.Note.IP.Web.Infrastructure;
using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.AddServiceDefaults();

builder.AddKeyVaultIfConfigured();
builder.AddApplicationServices();
builder.AddInfrastructureServices();
builder.AddWebServices();

var app = builder.Build();

// Skip DB init during OpenAPI document generation at build/publish time.
var isOpenApiDocumentGeneration = OpenApiDocumentGeneration.IsActive;

var databaseOptions = app.Configuration.GetSection(DatabaseOptions.SectionName).Get<DatabaseOptions>() ?? new DatabaseOptions();
if (!isOpenApiDocumentGeneration && (app.Environment.IsDevelopment() || databaseOptions.ApplyMigrationsOnStartup))
{
    await app.InitialiseDatabaseAsync();
}

if (app.Environment.IsDevelopment())
{
    app.UseHangfireDashboard("/hangfire", new DashboardOptions
    {
        Authorization = [new Hangfire.Dashboard.LocalRequestsOnlyAuthorizationFilter()]
    });
}
else
{
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();

    var forwardedHeaders = new ForwardedHeadersOptions
    {
        ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
    };
    forwardedHeaders.KnownIPNetworks.Clear();
    forwardedHeaders.KnownProxies.Clear();
    app.UseForwardedHeaders(forwardedHeaders);
}

app.UseHttpsRedirection();
app.UseSecurityHeaders();

var rewriteOptions = new RewriteOptions()
    .AddRewrite(@"^api/(?!v1/)(.*)", "api/v1/$1", skipRemainingRules: false);
app.UseRewriter(rewriteOptions);

var corsOptions = app.Configuration.GetSection(CorsOptions.SectionName).Get<CorsOptions>() ?? new CorsOptions();
if (corsOptions.AllowedOrigins.Length > 0)
{
    app.UseCors(policy => policy
        .WithOrigins(corsOptions.AllowedOrigins)
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials());
}
else if (app.Environment.IsDevelopment())
{
    app.UseCors(policy => policy
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowAnyOrigin());
}

app.UseFileServer();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}

app.UseExceptionHandler(options => { });

app.UseAuthentication();
app.UseAuthorization();

app.UseRateLimiter();

app.MapDefaultEndpoints();
app.MapEndpoints(typeof(Program).Assembly);

app.MapGet("/myIp", IpLookup.GetMyIpPlain)
    .AllowAnonymous()
    .RequireRateLimiting(GuestRateLimitPolicies.GuestApi)
    .WithSummary("GetMyIpPlain")
    .WithDescription("Short alias for GetMyIpPlain — returns caller IP as text/plain.")
    .Produces<string>(StatusCodes.Status200OK, "text/plain");

var wellKnownRoot = Path.Combine(app.Environment.WebRootPath, ".well-known");
app.MapGet("/.well-known/apple-app-site-association", () =>
    Results.File(
        Path.Combine(wellKnownRoot, "apple-app-site-association"),
        "application/json"));

// SPA fallback: serve index.html for client-side routes only. Reserved API and
// tooling prefixes must return 404 when unmatched instead of silently serving the
// SPA shell (e.g. /scalar in Production, /metrics when the exporter is disabled).
app.MapFallback(async context =>
{
    var path = context.Request.Path.Value ?? string.Empty;

    var isReservedNonSpaPath =
        path.StartsWith("/api", StringComparison.OrdinalIgnoreCase)
        || path.StartsWith("/scalar", StringComparison.OrdinalIgnoreCase)
        || path.StartsWith("/openapi", StringComparison.OrdinalIgnoreCase)
        || path.StartsWith("/metrics", StringComparison.OrdinalIgnoreCase);

    if (isReservedNonSpaPath)
    {
        context.Response.StatusCode = StatusCodes.Status404NotFound;
        return;
    }

    context.Response.ContentType = "text/html; charset=utf-8";
    await context.Response.SendFileAsync(
        Path.Combine(app.Environment.WebRootPath, "index.html"));
});

app.Run();
