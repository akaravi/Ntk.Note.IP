using System.Security.Cryptography;
using System.Text;

namespace Ntk.Note.IP.Web.Infrastructure;

public static class ClientAttestationHeaders
{
    public const string ClientId = "X-Client-Id";
    public const string Timestamp = "X-Client-Timestamp";
    public const string Signature = "X-Client-Signature";
}

public sealed class ClientHmacValidator
{
    private static readonly TimeSpan MaxClockSkew = TimeSpan.FromMinutes(5);

    public bool TryValidate(
        RegisteredClient client,
        string timestampHeader,
        string signatureHeader,
        HttpRequest request,
        out string failureReason)
    {
        failureReason = string.Empty;

        if (IsPlaceholderSecret(client.Secret))
        {
            return true;
        }

        if (!long.TryParse(timestampHeader, out var unixSeconds))
        {
            failureReason = "Invalid client timestamp.";
            return false;
        }

        var requestTime = DateTimeOffset.FromUnixTimeSeconds(unixSeconds);
        var skew = (DateTimeOffset.UtcNow - requestTime).Duration();
        if (skew > MaxClockSkew)
        {
            failureReason = "Client timestamp expired.";
            return false;
        }

        var payload = BuildPayload(client.ClientId, unixSeconds, request);
        var expected = ComputeSignature(client.Secret, payload);

        if (!FixedTimeEquals(expected, signatureHeader.Trim()))
        {
            failureReason = "Invalid client signature.";
            return false;
        }

        return true;
    }

    public static bool IsPlaceholderSecret(string secret)
    {
        if (string.IsNullOrWhiteSpace(secret))
        {
            return true;
        }

        return secret.StartsWith("CHANGE_ME", StringComparison.OrdinalIgnoreCase);
    }

    private static string BuildPayload(string clientId, long unixSeconds, HttpRequest request)
    {
        var path = request.Path.HasValue ? request.Path.Value! : "/";
        var query = request.QueryString.HasValue ? request.QueryString.Value! : string.Empty;
        return $"{clientId}:{unixSeconds}:{request.Method}:{path}{query}";
    }

    private static string ComputeSignature(string secret, string payload)
    {
        var key = Encoding.UTF8.GetBytes(secret);
        var data = Encoding.UTF8.GetBytes(payload);
        var hash = HMACSHA256.HashData(key, data);
        return Convert.ToHexString(hash).ToLowerInvariant();
    }

    private static bool FixedTimeEquals(string expectedHex, string providedHex)
    {
        if (string.IsNullOrWhiteSpace(providedHex))
        {
            return false;
        }

        try
        {
            var expected = Convert.FromHexString(expectedHex);
            var provided = Convert.FromHexString(providedHex);
            return expected.Length == provided.Length && CryptographicOperations.FixedTimeEquals(expected, provided);
        }
        catch (FormatException)
        {
            return false;
        }
    }
}

public sealed class ClientHmacValidationMiddleware(
    RequestDelegate next,
    IRegisteredClientStore clientStore,
    ClientHmacValidator validator,
    ILogger<ClientHmacValidationMiddleware> logger)
{
    public async Task InvokeAsync(HttpContext context)
    {
        var path = context.Request.Path.Value ?? string.Empty;
        if (!path.StartsWith("/api/", StringComparison.OrdinalIgnoreCase))
        {
            await next(context);
            return;
        }

        if (!context.Request.Headers.TryGetValue(ClientAttestationHeaders.ClientId, out var clientIdValues))
        {
            await next(context);
            return;
        }

        var clientId = clientIdValues.ToString().Trim();
        if (!clientStore.TryGet(clientId, out var client))
        {
            logger.LogWarning("Unknown client id {ClientId} on {Path}", clientId, path);
            context.Response.StatusCode = StatusCodes.Status401Unauthorized;
            await context.Response.WriteAsJsonAsync(new
            {
                isSuccess = false,
                errorMessage = "Unknown client."
            });
            return;
        }

        if (ClientHmacValidator.IsPlaceholderSecret(client.Secret))
        {
            await next(context);
            return;
        }

        context.Request.Headers.TryGetValue(ClientAttestationHeaders.Timestamp, out var timestampValues);
        context.Request.Headers.TryGetValue(ClientAttestationHeaders.Signature, out var signatureValues);

        if (!validator.TryValidate(
                client,
                timestampValues.ToString(),
                signatureValues.ToString(),
                context.Request,
                out var failureReason))
        {
            logger.LogWarning(
                "Client HMAC validation failed for {ClientId} on {Path}: {Reason}",
                clientId,
                path,
                failureReason);
            context.Response.StatusCode = StatusCodes.Status401Unauthorized;
            await context.Response.WriteAsJsonAsync(new
            {
                isSuccess = false,
                errorMessage = failureReason
            });
            return;
        }

        await next(context);
    }
}

public static class ClientHmacValidationMiddlewareExtensions
{
    public static IApplicationBuilder UseClientHmacValidation(this IApplicationBuilder app)
        => app.UseMiddleware<ClientHmacValidationMiddleware>();
}
