using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Application.IpTools.Queries.ActionCheckPort;

public record ActionCheckPortQuery(string Host, int Port) : IRequest<PortCheckResultDto>;

public class ActionCheckPortQueryValidator : AbstractValidator<ActionCheckPortQuery>
{
    public ActionCheckPortQueryValidator()
    {
        RuleFor(v => v.Host).NotEmpty().MaximumLength(253);
        RuleFor(v => v.Port).InclusiveBetween(1, 65535);
    }
}

public class ActionCheckPortQueryHandler : IRequestHandler<ActionCheckPortQuery, PortCheckResultDto>
{
    private readonly IPortCheckService _portCheckService;

    public ActionCheckPortQueryHandler(IPortCheckService portCheckService)
    {
        _portCheckService = portCheckService;
    }

    public Task<PortCheckResultDto> Handle(ActionCheckPortQuery request, CancellationToken cancellationToken) =>
        _portCheckService.CheckAsync(request.Host.Trim(), request.Port, cancellationToken);
}
