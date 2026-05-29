using Microsoft.Extensions.Logging;
using Moq;
using Ntk.Note.IP.Application.Common.Behaviours;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpNotes.Commands.AddIpNote;
using NUnit.Framework;

namespace Ntk.Note.IP.Application.UnitTests.Common.Behaviours;

public class RequestLoggerTests
{
    private Mock<ILogger<AddIpNoteCommand>> _logger = null!;
    private Mock<IUser> _user = null!;
    private Mock<IIdentityService> _identityService = null!;

    [SetUp]
    public void Setup()
    {
        _logger = new Mock<ILogger<AddIpNoteCommand>>();
        _user = new Mock<IUser>();
        _identityService = new Mock<IIdentityService>();
    }

    [Test]
    public async Task ShouldLogRequestWhenUserIsNull()
    {
        var requestLogger = new LoggingBehaviour<AddIpNoteCommand>(_logger.Object, _user.Object, _identityService.Object);

        await requestLogger.Process(new AddIpNoteCommand { Address = "8.8.8.8", Title = "test" }, new CancellationToken());

        _logger.Verify(x => x.Log(
            LogLevel.Information,
            It.IsAny<EventId>(),
            It.IsAny<It.IsAnyType>(),
            It.IsAny<Exception>(),
            It.IsAny<Func<It.IsAnyType, Exception?, string>>()), Times.Once);
    }

    [Test]
    public async Task ShouldLogRequestWhenUserIsNotNull()
    {
        _user.SetupGet(x => x.Id).Returns("user-1");
        var requestLogger = new LoggingBehaviour<AddIpNoteCommand>(_logger.Object, _user.Object, _identityService.Object);

        await requestLogger.Process(new AddIpNoteCommand { Address = "8.8.8.8", Title = "test" }, new CancellationToken());

        _logger.Verify(x => x.Log(
            LogLevel.Information,
            It.IsAny<EventId>(),
            It.IsAny<It.IsAnyType>(),
            It.IsAny<Exception>(),
            It.IsAny<Func<It.IsAnyType, Exception?, string>>()), Times.Once);
    }
}
