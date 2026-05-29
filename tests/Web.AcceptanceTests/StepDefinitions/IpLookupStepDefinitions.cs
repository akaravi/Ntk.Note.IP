namespace Ntk.Note.IP.Web.AcceptanceTests.StepDefinitions;

[Binding]
public sealed class IpLookupStepDefinitions(IpLookupPage ipLookupPage)
{
    [BeforeFeature("IpLookup")]
    public static async Task BeforeIpLookupFeature(IObjectContainer container)
    {
        var context = await PlaywrightSetup.Browser.NewContextAsync();
        var page = await context.NewPageAsync();
        container.RegisterInstanceAs(context);
        container.RegisterInstanceAs(new IpLookupPage(page));
    }

    [AfterFeature("IpLookup")]
    public static async Task AfterIpLookupFeature(IObjectContainer container)
    {
        var context = container.Resolve<IBrowserContext>();
        await context.DisposeAsync();
    }

    [Given("a user visits the IP lookup page")]
    public async Task GivenAUserVisitsTheIpLookupPage()
    {
        await ipLookupPage.GotoRootAsync();
        await ipLookupPage.ClearBrowserStorageAsync();
        await ipLookupPage.GotoRootAsync();
        await ipLookupPage.AssertOnIpLookupPageAsync();
    }

    [Then("the My IP address is visible")]
    public Task ThenTheMyIpAddressIsVisible() => ipLookupPage.AssertMyIpAddressVisibleAsync();

    [When("the user looks up {string}")]
    public Task WhenTheUserLooksUp(string address) => ipLookupPage.LookupAddressAsync(address);

    [Then("browser history contains {string}")]
    public Task ThenBrowserHistoryContains(string address) => ipLookupPage.AssertHistoryContainsAsync(address);
}
