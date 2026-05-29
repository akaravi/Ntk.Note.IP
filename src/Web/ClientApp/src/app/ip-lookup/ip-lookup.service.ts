import { HttpClient, HttpParams } from '@angular/common/http';
import { Inject, Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';
import { apiV1Group } from '../core/api-routes';
import { API_BASE_URL } from '../web-api-client';

export interface ErrorExceptionResult<T> {
  isSuccess: boolean;
  data?: T;
  errorCode?: string;
  errorMessage?: string;
}

export interface MyIpDto {
  address: string;
  scope: string;
  isIPv6: boolean;
}

export interface GeoLocationDto {
  latitude?: number;
  longitude?: number;
  countryCode?: string;
  country?: string;
  region?: string;
  city?: string;
  timezone?: string;
}

export interface AsnInfoDto {
  number?: string;
  organization?: string;
}

export interface IpDetailsDto {
  address: string;
  scope: string;
  isIPv6: boolean;
  geo: GeoLocationDto;
  asn: AsnInfoDto;
  isp?: string;
  reverseDns?: string;
}

export interface IpLookupRecordDto {
  id: number;
  address: string;
  countryCode?: string;
  region?: string;
  city?: string;
  asn?: string;
  isp?: string;
  created: string;
  lastModified: string;
}

@Injectable({ providedIn: 'root' })
export class IpLookupService {
  private readonly base: string;

  constructor(
    private readonly http: HttpClient,
    @Inject(API_BASE_URL) baseUrl: string
  ) {
    this.base = `${baseUrl}${apiV1Group('IpLookup')}`;
  }

  getMyIp(): Observable<MyIpDto> {
    return this.get<MyIpDto>('GetMyIp');
  }

  getMyIpPlain(): Observable<string> {
    return this.http.get(`${this.base}/GetMyIpPlain`, { responseType: 'text' });
  }

  getIpDetails(address: string): Observable<IpDetailsDto> {
    return this.get<IpDetailsDto>('GetIpDetails', address);
  }

  getListIpLookupRecords(): Observable<IpLookupRecordDto[]> {
    return this.get<IpLookupRecordDto[]>('GetListIpLookupRecords');
  }

  actionLookup(address: string): Observable<IpLookupRecordDto> {
    return this.http
      .post<ErrorExceptionResult<IpLookupRecordDto>>(`${this.base}/ActionLookup`, { address })
      .pipe(
        map((result) => {
          if (!result.isSuccess || result.data === undefined) {
            throw new Error(result.errorMessage ?? 'Request failed');
          }
          return result.data;
        })
      );
  }

  private get<T>(action: string, address?: string): Observable<T> {
    let params = new HttpParams();
    if (address) {
      params = params.set('address', address);
    }

    return this.http
      .get<ErrorExceptionResult<T>>(`${this.base}/${action}`, { params })
      .pipe(
        map((result) => {
          if (!result.isSuccess || result.data === undefined) {
            throw new Error(result.errorMessage ?? 'Request failed');
          }
          return result.data;
        })
      );
  }
}
