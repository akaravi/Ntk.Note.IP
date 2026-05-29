import { HttpClient, HttpParams } from '@angular/common/http';
import { Inject, Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';
import { apiV1Group } from '../core/api-routes';
import { API_BASE_URL } from '../web-api-client';
import { ErrorExceptionResult } from '../ip-lookup/ip-lookup.service';

export interface DnsRecordDto {
  type: string;
  name: string;
  value: string;
  preference?: number;
  ttl?: number;
}

export interface DnsResolveResultDto {
  domain: string;
  records: DnsRecordDto[];
}

export interface DnsPropagationResolverDto {
  resolverName: string;
  values: string[];
  matchesReference: boolean;
}

export interface DnsPropagationResultDto {
  domain: string;
  recordType: string;
  resolvers: DnsPropagationResolverDto[];
}

@Injectable({ providedIn: 'root' })
export class DnsService {
  private readonly base: string;

  constructor(
    private readonly http: HttpClient,
    @Inject(API_BASE_URL) baseUrl: string
  ) {
    this.base = `${baseUrl}${apiV1Group('Dns')}`;
  }

  resolveDns(domain: string, types?: string[]): Observable<DnsResolveResultDto> {
    let params = new HttpParams().set('domain', domain);
    if (types?.length) {
      types.forEach((t) => {
        params = params.append('types', t);
      });
    }

    return this.http
      .get<ErrorExceptionResult<DnsResolveResultDto>>(`${this.base}/ResolveDns`, { params })
      .pipe(
        map((result) => {
          if (!result.isSuccess || !result.data) {
            throw new Error(result.errorMessage ?? 'DNS resolve failed');
          }
          return result.data;
        })
      );
  }

  getListDnsPropagation(domain: string, type = 'A'): Observable<DnsPropagationResultDto> {
    const params = new HttpParams().set('domain', domain).set('type', type);

    return this.http
      .get<ErrorExceptionResult<DnsPropagationResultDto>>(`${this.base}/GetListDnsPropagation`, {
        params,
      })
      .pipe(
        map((result) => {
          if (!result.isSuccess || !result.data) {
            throw new Error(result.errorMessage ?? 'DNS propagation check failed');
          }
          return result.data;
        })
      );
  }
}
