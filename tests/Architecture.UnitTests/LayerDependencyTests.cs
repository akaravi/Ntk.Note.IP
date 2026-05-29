using NetArchTest.Rules;
using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Domain.Common;
using Ntk.Note.IP.Domain.Entities;

namespace Ntk.Note.IP.Architecture.UnitTests;

[TestFixture]
public class LayerDependencyTests
{
    private const string ApplicationNamespace = "Ntk.Note.IP.Application";
    private const string InfrastructureNamespace = "Ntk.Note.IP.Infrastructure";
    private const string WebNamespace = "Ntk.Note.IP.Web";

    [Test]
    public void Domain_ShouldNotReference_OuterLayers()
    {
        var result = Types.InAssembly(typeof(IpNote).Assembly)
            .ShouldNot()
            .HaveDependencyOnAny(ApplicationNamespace, InfrastructureNamespace, WebNamespace)
            .GetResult();

        Assert.That(result.IsSuccessful, Is.True, FormatFailingTypes(result));
    }

    [Test]
    public void Application_ShouldNotReference_Infrastructure_Or_Web()
    {
        var result = Types.InAssembly(typeof(ErrorExceptionResult).Assembly)
            .ShouldNot()
            .HaveDependencyOnAny(InfrastructureNamespace, WebNamespace)
            .GetResult();

        Assert.That(result.IsSuccessful, Is.True, FormatFailingTypes(result));
    }

    [Test]
    public void DomainEntities_ShouldReside_InEntitiesNamespace()
    {
        var result = Types.InAssembly(typeof(IpNote).Assembly)
            .That()
            .Inherit(typeof(BaseAuditableEntity))
            .Should()
            .ResideInNamespace("Ntk.Note.IP.Domain.Entities")
            .GetResult();

        Assert.That(result.IsSuccessful, Is.True, FormatFailingTypes(result));
    }

    private static string FormatFailingTypes(TestResult result) =>
        result.FailingTypes is { } types && types.Any()
            ? string.Join(Environment.NewLine, types.Select(t => t.FullName))
            : "No failing types reported.";
}
