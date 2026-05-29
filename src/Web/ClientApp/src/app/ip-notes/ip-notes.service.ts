import { HttpClient } from '@angular/common/http';
import { Inject, Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';
import { apiV1Group } from '../core/api-routes';
import { API_BASE_URL } from '../web-api-client';
import { ErrorExceptionResult, GeoLocationDto, AsnInfoDto } from '../ip-lookup/ip-lookup.service';

export interface IpNoteDeviceInfoDto {
  browser: string;
  os: string;
  deviceType: string;
  language: string;
  label: string;
  userAgent?: string;
}

export interface IpNoteIpSnapshotDto {
  address: string;
  scope: string;
  isIPv6: boolean;
  geo: GeoLocationDto;
  asn: AsnInfoDto;
  isp?: string;
  reverseDns?: string;
}

export interface IpNoteDto {
  id: number;
  address: string;
  title?: string;
  body?: string;
  tags?: string;
  created: string;
  lastModified: string;
  notedAtClient?: string;
  clientTimezone?: string;
  localIpAddress?: string;
  countryCode?: string;
  region?: string;
  city?: string;
  isp?: string;
  asn?: string;
  deviceLabel?: string;
  deviceInfo?: IpNoteDeviceInfoDto;
  ipSnapshot?: IpNoteIpSnapshotDto;
}

export interface AddIpNoteCommand {
  address: string;
  title?: string;
  body?: string;
  tags?: string;
  notedAtClient?: string;
  clientTimezone?: string;
  localIpAddress?: string;
  deviceInfo?: IpNoteDeviceInfoDto;
  ipSnapshot?: IpNoteIpSnapshotDto;
}

@Injectable({ providedIn: 'root' })
export class IpNotesService {
  private readonly base: string;

  constructor(
    private readonly http: HttpClient,
    @Inject(API_BASE_URL) baseUrl: string
  ) {
    this.base = `${baseUrl}${apiV1Group('IpNotes')}`;
  }

  getList(): Observable<IpNoteDto[]> {
    return this.http
      .get<ErrorExceptionResult<IpNoteDto[]>>(this.base)
      .pipe(this.unwrapList());
  }

  add(command: AddIpNoteCommand): Observable<number> {
    return this.http
      .post<ErrorExceptionResult<number>>(this.base, command)
      .pipe(
        map((result) => {
          if (!result.isSuccess || result.data === undefined) {
            throw new Error(result.errorMessage ?? 'Add failed');
          }
          return result.data;
        })
      );
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.base}/${id}`);
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
