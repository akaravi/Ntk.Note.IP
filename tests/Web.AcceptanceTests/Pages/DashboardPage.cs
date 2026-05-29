namespace Ntk.Note.IP.Web.AcceptanceTests.Pages;

public class DashboardPage(IPage page) : BasePage(page)
{
    public override string PagePath => $"{BaseUrl}/dashboard";

    public Task AssertPageVisibleAsync()
        => Assertions.Expect(Page.Locator("[data-testid='dashboard-page']")).ToBeVisibleAsync(
            new LocatorAssertionsToBeVisibleOptions { Timeout = 15_000 });

    public Task AssertStatsVisibleAsync()
        => Assertions.Expect(Page.Locator("[data-testid='dashboard-stats']")).ToBeVisibleAsync();

    public async Task<string> DownloadCsvExportAsync()
    {
        var download = await Page.RunAndWaitForDownloadAsync(() =>
            Page.Locator("[data-testid='dashboard-export-csv']").ClickAsync());

        var path = await download.PathAsync();
        path.ShouldNotBeNull();
        return await File.ReadAllTextAsync(path);
    }

    public Task AssertCsvExportHasHeaderAsync(string csv)
    {
        csv.ShouldContain("kind,address,recordedAt");
        return Task.CompletedTask;
    }
}
