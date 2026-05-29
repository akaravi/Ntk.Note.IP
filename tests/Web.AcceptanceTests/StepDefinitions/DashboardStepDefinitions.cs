namespace Ntk.Note.IP.Web.AcceptanceTests.StepDefinitions;

[Binding]
public sealed class DashboardStepDefinitions(
    LoginPage loginPage,
    DashboardPage dashboardPage,
    ScenarioContext scenarioContext)
{
    private const string AdminEmail = "administrator@localhost";
    private const string AdminPassword = "Administrator1!";

    [BeforeFeature("Dashboard")]
    public static async Task BeforeDashboardFeature(IObjectContainer container)
    {
        var context = await PlaywrightSetup.Browser.NewContextAsync();
        var page = await context.NewPageAsync();
        container.RegisterInstanceAs(context);
        container.RegisterInstanceAs(new LoginPage(page));
        container.RegisterInstanceAs(new DashboardPage(page));
    }

    [AfterFeature("Dashboard")]
    public static async Task AfterDashboardFeature(IObjectContainer container)
    {
        var context = container.Resolve<IBrowserContext>();
        await context.DisposeAsync();
    }

    [Given("a logged in user on the dashboard")]
    public async Task GivenALoggedInUserOnTheDashboard()
    {
        await loginPage.GotoAsync();
        await loginPage.SetEmail(AdminEmail);
        await loginPage.SetPassword(AdminPassword);
        await loginPage.ClickLogin();
        await dashboardPage.AssertPageVisibleAsync();
    }

    [Then("dashboard statistics are visible")]
    public Task ThenDashboardStatisticsAreVisible() => dashboardPage.AssertStatsVisibleAsync();

    [When("the user exports dashboard CSV")]
    public async Task WhenTheUserExportsDashboardCsv()
    {
        var csv = await dashboardPage.DownloadCsvExportAsync();
        scenarioContext.Set(csv, "dashboardCsv");
    }

    [Then("the CSV export contains a header row")]
    public Task ThenTheCsvExportContainsAHeaderRow()
    {
        var csv = scenarioContext.Get<string>("dashboardCsv");
        return dashboardPage.AssertCsvExportHasHeaderAsync(csv);
    }
}
