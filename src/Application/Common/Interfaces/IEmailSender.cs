namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface IEmailSender
{
    Task SendAsync(
        string to,
        string subject,
        string plainTextBody,
        string? htmlBody = null,
        CancellationToken cancellationToken = default);
}
