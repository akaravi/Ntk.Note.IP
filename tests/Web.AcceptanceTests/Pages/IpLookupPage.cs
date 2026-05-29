using System.Text.RegularExpressions;

namespace Ntk.Note.IP.Web.AcceptanceTests.Pages;

public partial class IpLookupPage(IPage page) : BasePage(page)
{
    private static readonly Regex MyIpAddressPattern = MyIpAddressRegex();

    public override string PagePath => $"{BaseUrl}/ip-lookup";

    public Task GotoRootAsync() => Page.GotoAsync(BaseUrl);

    public Task AssertOnIpLookupPageAsync()
        => Assertions.Expect(Page.Locator("[data-testid='ip-lookup-page']")).ToBeVisibleAsync();

    public Task AssertMyIpAddressVisibleAsync()
    {
        var locator = Page.Locator("[data-testid='my-ip-address']");
        return Assertions.Expect(locator).ToHaveTextAsync(MyIpAddressPattern);
    }

    public async Task LookupAddressAsync(string address)
    {
        await Page.Locator("[data-testid='ip-address-input']").FillAsync(address);
        await Page.Locator("[data-testid='ip-lookup-submit']").ClickAsync();
    }

    public Task AssertHistoryContainsAsync(string address)
    {
        var items = Page.Locator("[data-testid='ip-history-item']");
        return Assertions.Expect(items.Filter(new LocatorFilterOptions { HasText = address })).ToHaveCountAsync(
            1,
            new LocatorAssertionsToHaveCountOptions { Timeout = 15_000 });
    }

    public async Task ClearBrowserStorageAsync()
    {
        await Page.EvaluateAsync(
            """() => { localStorage.removeItem('ipnote.ip-history'); localStorage.removeItem('ipnote.locale'); }""");
    }

    [GeneratedRegex(@"^(\d{1,3}\.){3}\d{1,3}$|^([0-9a-fA-F:]+)$")]
    private static partial Regex MyIpAddressRegex();
}
