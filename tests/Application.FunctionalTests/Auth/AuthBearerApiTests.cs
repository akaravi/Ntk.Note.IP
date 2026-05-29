using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Serialization;
using Ntk.Note.IP.Application.FunctionalTests.Infrastructure;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.FunctionalTests.Auth;

public class AuthBearerApiTests : TestBase
{
    [Test]
    public async Task BearerTokenShouldAuthorizeIpNotesEndpoint()
    {
        const string email = "bearer-api@test.local";
        const string password = "Testing1234!";

        await TestApp.RunAsUserAsync(email, password, []);

        var loginResponse = await FunctionalTestSetup.HttpClient.PostAsJsonAsync(
            "/api/v1/Users/login",
            new LoginPayload(email, password));

        loginResponse.EnsureSuccessStatusCode();
        var tokens = await loginResponse.Content.ReadFromJsonAsync<AccessTokenPayload>();
        tokens.ShouldNotBeNull();
        tokens!.AccessToken.ShouldNotBeNullOrWhiteSpace();

        using var request = new HttpRequestMessage(HttpMethod.Get, "/api/v1/IpNotes");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", tokens.AccessToken);

        var notesResponse = await FunctionalTestSetup.HttpClient.SendAsync(request);
        notesResponse.StatusCode.ShouldBe(HttpStatusCode.OK);
    }

    private sealed record LoginPayload(string Email, string Password);

    private sealed record AccessTokenPayload(
        [property: JsonPropertyName("accessToken")] string AccessToken,
        [property: JsonPropertyName("tokenType")] string? TokenType);
}
