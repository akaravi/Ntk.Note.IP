import { HttpClient, HttpParams } from '@angular/common/http';
import { Inject, Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';
import { apiV1Group } from '../core/api-routes';
import { API_BASE_URL } from '../web-api-client';
import { ErrorExceptionResult, IpLookupRecordDto } from '../ip-lookup/ip-lookup.service';

export interface AdminDashboardDto {
  userCount: number;
  roleCount: number;
  ipNoteCount: number;
  ipLookupRecordCount: number;
  pushDeviceCount: number;
  outboxPendingCount: number;
  ipSnapshotCount: number;
  supportTicketOpenCount: number;
}

export interface AdminAccessDto {
  isAdministrator: boolean;
  roles: string[];
}

export interface AdminUserDto {
  id: string;
  email?: string;
  userName?: string;
  emailConfirmed: boolean;
  lockoutEnd?: string;
  roles: string[];
}

export interface AdminIpNoteListItemDto {
  id: number;
  address: string;
  title?: string;
  body?: string;
  tags?: string;
  ownerId?: string;
  ownerEmail?: string;
  created: string;
  lastModified: string;
  countryCode?: string;
  city?: string;
  deviceLabel?: string;
  isSoftDeleted: boolean;
}

export interface AdminPushDeviceDto {
  id: number;
  deviceToken: string;
  platform: string;
  ownerId?: string;
  created: string;
  lastModified: string;
}

export interface AdminOutboxMessageDto {
  id: string;
  type: string;
  occurredOn: string;
  processedOn?: string;
  error?: string;
  contentLength: number;
}

export interface AdminRoleDto {
  id: string;
  name: string;
  userCount: number;
  permissions: string[];
  isSystem: boolean;
}

export interface AdminPermissionCatalogItemDto {
  key: string;
  groupKey: string;
}

export interface AdminSupportTicketDto {
  id: number;
  name: string;
  email: string;
  subject: string;
  message: string;
  status: string;
  emailSent: boolean;
  emailError?: string;
  userId?: string;
  created: string;
}

@Injectable({ providedIn: 'root' })
export class AdminService {
  private readonly dashboardBase: string;
  private readonly accessBase: string;
  private readonly usersBase: string;
  private readonly notesBase: string;
  private readonly lookupsBase: string;
  private readonly pushBase: string;
  private readonly outboxBase: string;
  private readonly rolesBase: string;
  private readonly ticketsBase: string;

  constructor(
    private readonly http: HttpClient,
    @Inject(API_BASE_URL) baseUrl: string
  ) {
    this.dashboardBase = `${baseUrl}${apiV1Group('AdminDashboard')}`;
    this.accessBase = `${baseUrl}${apiV1Group('AdminAccess')}`;
    this.usersBase = `${baseUrl}${apiV1Group('AdminUsers')}`;
    this.notesBase = `${baseUrl}${apiV1Group('AdminIpNotes')}`;
    this.lookupsBase = `${baseUrl}${apiV1Group('AdminIpLookupRecords')}`;
    this.pushBase = `${baseUrl}${apiV1Group('AdminPushDevices')}`;
    this.outboxBase = `${baseUrl}${apiV1Group('AdminOutbox')}`;
    this.rolesBase = `${baseUrl}${apiV1Group('AdminRoles')}`;
    this.ticketsBase = `${baseUrl}${apiV1Group('AdminSupportTickets')}`;
  }

  getAccess(): Observable<AdminAccessDto> {
    return this.http
      .get<ErrorExceptionResult<AdminAccessDto>>(`${this.accessBase}/GetOne`)
      .pipe(this.unwrap());
  }

  getDashboard(): Observable<AdminDashboardDto> {
    return this.http
      .get<ErrorExceptionResult<AdminDashboardDto>>(`${this.dashboardBase}/GetOne`)
      .pipe(this.unwrap());
  }

  getUsers(): Observable<AdminUserDto[]> {
    return this.http
      .get<ErrorExceptionResult<AdminUserDto[]>>(`${this.usersBase}/GetList`)
      .pipe(this.unwrapList());
  }

  setUserRoles(userId: string, roles: string[]): Observable<void> {
    return this.http.post<void>(`${this.usersBase}/ActionSetRoles`, { userId, roles });
  }

  getIpNotes(search?: string): Observable<AdminIpNoteListItemDto[]> {
    let params = new HttpParams();
    if (search?.trim()) {
      params = params.set('search', search.trim());
    }
    return this.http
      .get<ErrorExceptionResult<AdminIpNoteListItemDto[]>>(`${this.notesBase}/GetList`, { params })
      .pipe(this.unwrapList());
  }

  deleteIpNote(id: number): Observable<void> {
    return this.http.delete<void>(`${this.notesBase}/${id}`);
  }

  getIpLookups(search?: string): Observable<IpLookupRecordDto[]> {
    let params = new HttpParams();
    if (search?.trim()) {
      params = params.set('search', search.trim());
    }
    return this.http
      .get<ErrorExceptionResult<IpLookupRecordDto[]>>(`${this.lookupsBase}/GetList`, { params })
      .pipe(this.unwrapList());
  }

  deleteIpLookup(id: number): Observable<void> {
    return this.http.delete<void>(`${this.lookupsBase}/${id}`);
  }

  getPushDevices(): Observable<AdminPushDeviceDto[]> {
    return this.http
      .get<ErrorExceptionResult<AdminPushDeviceDto[]>>(`${this.pushBase}/GetList`)
      .pipe(this.unwrapList());
  }

  deletePushDevice(id: number): Observable<void> {
    return this.http.delete<void>(`${this.pushBase}/${id}`);
  }

  getOutbox(pendingOnly = false): Observable<AdminOutboxMessageDto[]> {
    const params = new HttpParams().set('pendingOnly', pendingOnly);
    return this.http
      .get<ErrorExceptionResult<AdminOutboxMessageDto[]>>(`${this.outboxBase}/GetList`, { params })
      .pipe(this.unwrapList());
  }

  getRoles(): Observable<AdminRoleDto[]> {
    return this.http
      .get<ErrorExceptionResult<AdminRoleDto[]>>(`${this.rolesBase}/GetList`)
      .pipe(this.unwrapList());
  }

  getPermissionCatalog(): Observable<AdminPermissionCatalogItemDto[]> {
    return this.http
      .get<ErrorExceptionResult<AdminPermissionCatalogItemDto[]>>(`${this.rolesBase}/GetListPermissions`)
      .pipe(this.unwrapList());
  }

  addRole(name: string, permissions: string[]): Observable<void> {
    return this.http.post<void>(`${this.rolesBase}/Add`, { name, permissions });
  }

  updateRolePermissions(roleId: string, permissions: string[]): Observable<void> {
    return this.http.post<void>(`${this.rolesBase}/UpdatePermissions`, { roleId, permissions });
  }

  deleteRole(roleId: string): Observable<void> {
    return this.http.delete<void>(`${this.rolesBase}/${roleId}`);
  }

  getSupportTickets(openOnly = false): Observable<AdminSupportTicketDto[]> {
    const params = new HttpParams().set('openOnly', openOnly);
    return this.http
      .get<ErrorExceptionResult<AdminSupportTicketDto[]>>(`${this.ticketsBase}/GetList`, { params })
      .pipe(this.unwrapList());
  }

  updateSupportTicketStatus(id: number, status: 'Open' | 'Closed'): Observable<void> {
    return this.http.post<void>(`${this.ticketsBase}/ActionUpdateStatus`, { id, status });
  }

  private unwrap<T>() {
    return map((result: ErrorExceptionResult<T>) => {
      if (!result.isSuccess || result.data === undefined) {
        throw new Error(result.errorMessage ?? 'Request failed');
      }
      return result.data;
    });
  }

  private unwrapList<T>() {
    return map((result: ErrorExceptionResult<T[]>) => {
      if (!result.isSuccess || !result.data) {
        throw new Error(result.errorMessage ?? 'Request failed');
      }
      return result.data;
    });
  }
}
