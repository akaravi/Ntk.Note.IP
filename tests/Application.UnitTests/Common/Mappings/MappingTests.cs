using System.Runtime.CompilerServices;
using AutoMapper;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpNotes;
using Ntk.Note.IP.Domain.Entities;
using Microsoft.Extensions.Logging;
using NUnit.Framework;

namespace Ntk.Note.IP.Application.UnitTests.Common.Mappings;

public class MappingTests
{
    private ILoggerFactory? _loggerFactory;
    private MapperConfiguration? _configuration;
    private IMapper? _mapper;

    [OneTimeSetUp]
    public void OneTimeSetUp()
    {
        _loggerFactory = LoggerFactory.Create(b => b.AddDebug().SetMinimumLevel(LogLevel.Debug));

        _configuration = new MapperConfiguration(cfg =>
            cfg.AddMaps(typeof(IApplicationDbContext).Assembly),
            loggerFactory: _loggerFactory);

        _mapper = _configuration.CreateMapper();
    }

    [Test]
    public void ShouldHaveValidConfiguration()
    {
        _configuration!.AssertConfigurationIsValid();
    }

    [Test]
    [TestCase(typeof(IpNote), typeof(IpNoteDto))]
    public void ShouldSupportMappingFromSourceToDestination(Type source, Type destination)
    {
        var instance = GetInstanceOf(source);

        _mapper!.Map(instance, source, destination);
    }

    private static object GetInstanceOf(Type type)
    {
        if (type.GetConstructor(Type.EmptyTypes) != null)
            return Activator.CreateInstance(type)!;

        return RuntimeHelpers.GetUninitializedObject(type);
    }

    [OneTimeTearDown]
    public void OneTimeTearDown()
    {
        _loggerFactory?.Dispose();
    }
}
