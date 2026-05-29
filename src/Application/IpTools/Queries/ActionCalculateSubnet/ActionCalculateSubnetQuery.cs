namespace Ntk.Note.IP.Application.IpTools.Queries.ActionCalculateSubnet;

public record ActionCalculateSubnetQuery(string Cidr) : IRequest<SubnetInfoDto>;

public class ActionCalculateSubnetQueryValidator : AbstractValidator<ActionCalculateSubnetQuery>
{
    public ActionCalculateSubnetQueryValidator()
    {
        RuleFor(v => v.Cidr).NotEmpty();
    }
}

public class ActionCalculateSubnetQueryHandler : IRequestHandler<ActionCalculateSubnetQuery, SubnetInfoDto>
{
    public Task<SubnetInfoDto> Handle(ActionCalculateSubnetQuery request, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        return Task.FromResult(CidrCalculator.Calculate(request.Cidr));
    }
}
