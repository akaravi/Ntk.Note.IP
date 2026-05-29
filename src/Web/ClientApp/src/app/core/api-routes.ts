/** Must match {@link Ntk.Note.IP.Web.Infrastructure.ApiRoutes.VersionPrefix}. */
export const API_V1_PREFIX = '/api/v1';

export function apiV1Group(groupName: string): string {
  return `${API_V1_PREFIX}/${groupName}`;
}
