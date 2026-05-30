using System.Net;
using System.Net.Mail;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Options;

namespace Ntk.Note.IP.Infrastructure.Email;

public sealed class SmtpEmailSender : IEmailSender
{
    private readonly SmtpOptions _smtp;
    private readonly SiteOptions _site;
    private readonly ILogger<SmtpEmailSender> _logger;

    public SmtpEmailSender(
        IOptions<SmtpOptions> smtp,
        IOptions<SiteOptions> site,
        ILogger<SmtpEmailSender> logger)
    {
        _smtp = smtp.Value;
        _site = site.Value;
        _logger = logger;
    }

    public async Task SendAsync(
        string to,
        string subject,
        string plainTextBody,
        string? htmlBody = null,
        CancellationToken cancellationToken = default)
    {
        if (!_smtp.Enabled)
        {
            throw new InvalidOperationException("SMTP is disabled in configuration.");
        }

        if (string.IsNullOrWhiteSpace(_smtp.Host))
        {
            throw new InvalidOperationException("SMTP host is not configured.");
        }

        using var message = new MailMessage
        {
            From = new MailAddress(_site.ContactFromEmail, _site.ContactFromName),
            Subject = subject,
            Body = htmlBody ?? plainTextBody,
            IsBodyHtml = htmlBody != null,
        };

        if (htmlBody != null)
        {
            message.AlternateViews.Add(
                AlternateView.CreateAlternateViewFromString(plainTextBody, null, "text/plain"));
        }

        message.To.Add(to);

        using var client = new SmtpClient(_smtp.Host, _smtp.Port)
        {
            EnableSsl = _smtp.UseSsl,
            DeliveryMethod = SmtpDeliveryMethod.Network,
        };

        if (!string.IsNullOrWhiteSpace(_smtp.UserName))
        {
            client.Credentials = new NetworkCredential(_smtp.UserName, _smtp.Password);
        }

        _logger.LogInformation("Sending email to {Recipient} with subject {Subject}", to, subject);
        await client.SendMailAsync(message, cancellationToken);
    }
}
