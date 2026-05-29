import { Injectable } from '@angular/core';
import { catchError, forkJoin, map, Observable, of, switchMap } from 'rxjs';
import { IpHistoryService } from './ip-history.service';
import { IpLookupRecordDto, IpLookupService } from '../ip-lookup/ip-lookup.service';

@Injectable({ providedIn: 'root' })
export class IpHistorySyncService {
  private syncedThisSession = false;

  constructor(
    private readonly ipLookup: IpLookupService,
    private readonly ipHistory: IpHistoryService
  ) {}

  syncAfterAuthentication(): Observable<void> {
    if (this.syncedThisSession) {
      return of(void 0);
    }

    return this.ipLookup.getListIpLookupRecords().pipe(
      switchMap((serverRecords) => {
        this.mergeServerIntoLocal(serverRecords);
        const serverAddresses = new Set(
          serverRecords.map((r) => r.address.toLowerCase())
        );
        const toUpload = this.ipHistory
          .getEntries()
          .filter((entry) => !serverAddresses.has(entry.address.toLowerCase()));

        if (toUpload.length === 0) {
          this.syncedThisSession = true;
          return of(void 0);
        }

        return forkJoin(
          toUpload.map((entry) =>
            this.ipLookup.actionLookup(entry.address).pipe(catchError(() => of(null)))
          )
        ).pipe(map(() => void 0));
      }),
      map(() => {
        this.syncedThisSession = true;
      }),
      catchError(() => of(void 0))
    );
  }

  resetSession(): void {
    this.syncedThisSession = false;
  }

  private mergeServerIntoLocal(serverRecords: IpLookupRecordDto[]): void {
    for (const record of serverRecords) {
      this.ipHistory.add({
        address: record.address,
        isIPv6: record.address.includes(':'),
        city: record.city ?? undefined,
        countryCode: record.countryCode ?? undefined,
        recordedAt: record.created,
      });
    }
  }
}
