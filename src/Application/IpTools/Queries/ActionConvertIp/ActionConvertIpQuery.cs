using System.Net;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpTools.Queries.ActionConvertIp;

public record ActionConvertIpQuery : IRequest<ConvertIpResultDto>
{
    public string? Address { get; init; }

    public uint? UInt32 { get; init; }
}

public class ActionConvertIpQueryValidator : AbstractValidator<ActionConvertIpQuery>
{
    public ActionConvertIpQueryValidator()
    {
        RuleFor(v => v)
            .Must(q => !string.IsNullOrWhiteSpace(q.Address) || q.UInt32.HasValue)
            .WithMessage("Provide either Address or UInt32.");
    }
}

public class ActionConvertIpQueryHandler : IRequestHandler<ActionConvertIpQuery, ConvertIpResultDto>
{
    public Task<ConvertIpResultDto> Handle(ActionConvertIpQuery request, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();

        IpAddress ip;
        if (request.UInt32.HasValue)
        {
            ip = IpAddress.FromUInt32(request.UInt32.Value)
                 ?? throw new ArgumentException("UInt32 value is not a valid IPv4 address.");
        }
        else
        {
            ip = IpAddress.Parse(request.Address!);
        }

        uint? asUInt = ip.ToUInt32();
        string? hex = null;
        string? compressed = null;

        if (ip.IsIPv4 && asUInt.HasValue)
        {
            hex = $"0x{asUInt.Value:X8}";
        }

        if (ip.IsIPv6 && IPAddress.TryParse(ip.Value, out var parsed))
        {
            compressed = parsed.ToString();
        }

        return Task.FromResult(new ConvertIpResultDto
        {
            Address = ip.Value,
            CompressedIPv6 = compressed,
            UInt32 = asUInt,
            Hex = hex,
            IsIPv6 = ip.IsIPv6
        });
    }
}
