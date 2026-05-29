using Hangfire;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Options;

namespace Ntk.Note.IP.Infrastructure.BackgroundJobs;

public sealed class HangfireJobRegistration(IOptions<PushOptions> pushOptions) : IHostedService
{
    public Task StartAsync(CancellationToken cancellationToken)
    {
        RecurringJob.AddOrUpdate<GeoIpDatabaseRefreshJob>(
            "geoip-mmdb-refresh",
            job => job.ExecuteAsync(CancellationToken.None),
            Cron.Daily);

        RecurringJob.AddOrUpdate<ProcessOutboxJob>(
            "outbox-dispatch",
            job => job.ExecuteAsync(CancellationToken.None),
            Cron.Minutely);

        var push = pushOptions.Value;
        if (push.IpMonitorPollJobEnabled)
        {
            var cron = string.IsNullOrWhiteSpace(push.IpMonitorPollCron)
                ? "*/15 * * * *"
                : push.IpMonitorPollCron;

            RecurringJob.AddOrUpdate<PushIpMonitorPollJob>(
                "push-ip-monitor-poll",
                job => job.ExecuteAsync(CancellationToken.None),
                cron);
        }

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
