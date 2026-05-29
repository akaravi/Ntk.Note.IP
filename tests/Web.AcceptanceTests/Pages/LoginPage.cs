namespace Ntk.Note.IP.Web.AcceptanceTests.Pages;

public class LoginPage(IPage page) : BasePage(page)
{
    public override string PagePath => $"{BaseUrl}/login";

    public Task SetEmail(string email)
        => Page.FillAsync("#email", email);

    public Task SetPassword(string password)
        => Page.FillAsync("#password", password);

    public Task ClickLogin()
        => Page.Locator("button[type='submit']").ClickAsync();

    public Task AssertLogoutVisibleAsync()
        => Assertions.Expect(Page.Locator("[data-testid='nav-logout']")).ToBeVisibleAsync(
            new LocatorAssertionsToBeVisibleOptions { Timeout = 15_000 });

    public Task AssertErrorVisible()
        => Assertions.Expect(Page.Locator("#login-error")).ToBeVisibleAsync();
}
