/** Must match {@link Ntk.Note.IP.Web.Infrastructure.ApiRoutes.VersionPrefix}. */
export const API_V1_PREFIX = '/api/v1';

/** Short alias for GetMyIpPlain — must match {@link Program} MapGet("/myIp"). */
export const MY_IP_SHORT_PATH = '/myip';

export function apiV1Group(groupName: string): string {
  return `${API_V1_PREFIX}/${groupName}`;
}
