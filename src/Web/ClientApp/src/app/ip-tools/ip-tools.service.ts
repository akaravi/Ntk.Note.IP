import { HttpClient, HttpParams } from '@angular/common/http';
import { Inject, Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';
import { API_BASE_URL } from '../web-api-client';
import { ErrorExceptionResult } from '../ip-lookup/ip-lookup.service';

export interface WhoisDomainDto {
  domain: string;
  handle?: string;
  name?: string;
  nameServers: string[];
  status?: string;
  registrationDate?: string;
  expirationDate?: string;
}

export interface PortCheckResultDto {
  host: string;
  port: number;
  isOpen: boolean;
  latencyMs?: number;
  errorMessage?: string;
}

export interface SslCertificateInfoDto {
  host: string;
  port: number;
  subject?: string;
  issuer?: string;
  notBefore?: string;
  notAfter?: string;
  thumbprint?: string;
  isValidNow: boolean;
}

export interface WhoisIpDto {
  address: string;
  handle?: string;
  name?: string;
  country?: string;
  startAddress?: string;
  endAddress?: string;
  type?: string;
  registrationDate?: string;
}

export interface BlacklistHitDto {
  listId: string;
  listName: string;
  responseCode: string;
  isListed: boolean;
}

export interface PrivacyFlagsDto {
  address: string;
  proxy: boolean;
  hosting: boolean;
  mobile: boolean;
  tor: boolean;
}

export interface SubnetInfoDto {
  cidr: string;
  networkAddress: string;
  broadcastAddress: string;
  firstHost: string;
  lastHost: string;
  prefixLength: number;
  usableHosts: number;
}

@Injectable({ providedIn: 'root' })
export class IpToolsService {
  constructor(
    private readonly http: HttpClient,
    @Inject(API_BASE_URL) private readonly baseUrl: string
  ) {}

  getWhoisIp(address: string): Observable<WhoisIpDto> {
    return this.get<WhoisIpDto>('Whois', 'GetWhoisIp', { address });
  }

  getWhoisDomain(domain: string): Observable<WhoisDomainDto> {
    return this.get<WhoisDomainDto>('Whois', 'GetWhoisDomain', { domain });
  }

  checkPort(host: string, port: number): Observable<PortCheckResultDto> {
    return this.get<PortCheckResultDto>('IpTools', 'ActionCheckPort', {
      host,
      port: String(port),
    });
  }

  getSslCertificate(domain: string, port = 443): Observable<SslCertificateInfoDto> {
    return this.get<SslCertificateInfoDto>('IpTools', 'GetSslCertificateInfo', {
      domain,
      port: String(port),
    });
  }

  getListBlacklist(address: string): Observable<BlacklistHitDto[]> {
    return this.get<BlacklistHitDto[]>('Blacklist', 'GetList', { address });
  }

  getPrivacyFlags(address: string): Observable<PrivacyFlagsDto> {
    return this.get<PrivacyFlagsDto>('IpTools', 'GetPrivacyFlags', { address });
  }

  calculateSubnet(cidr: string): Observable<SubnetInfoDto> {
    return this.get<SubnetInfoDto>('IpTools', 'ActionCalculateSubnet', { cidr });
  }

  private get<T>(group: string, action: string, params: Record<string, string>): Observable<T> {
    let httpParams = new HttpParams();
    for (const [key, value] of Object.entries(params)) {
      httpParams = httpParams.set(key, value);
    }

    return this.http
      .get<ErrorExceptionResult<T>>(`${this.baseUrl}/api/v1/${group}/${action}`, { params: httpParams })
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
