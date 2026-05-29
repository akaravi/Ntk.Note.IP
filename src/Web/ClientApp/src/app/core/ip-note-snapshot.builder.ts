import { Injectable, inject } from '@angular/core';
import { forkJoin, from, map, Observable, of } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { DeviceInfoService } from './device-info.service';
import { LocalIpService } from './local-ip.service';
import { IpDetailsDto, IpLookupService } from '../ip-lookup/ip-lookup.service';
import { AddIpNoteCommand, IpNoteDeviceInfoDto } from '../ip-notes/ip-notes.service';

@Injectable({ providedIn: 'root' })
export class IpNoteSnapshotBuilder {
  private readonly ipLookup = inject(IpLookupService);
  private readonly deviceInfo = inject(DeviceInfoService);
  private readonly localIp = inject(LocalIpService);

  buildForAddress(address: string): Observable<Partial<AddIpNoteCommand>> {
    const device = this.deviceInfo.getSummary();
    const deviceDto: IpNoteDeviceInfoDto = {
      browser: device.browser,
      os: device.os,
      deviceType: device.device,
      language: device.language,
      label: device.label,
      userAgent: device.userAgent,
    };

    return forkJoin({
      details: this.ipLookup.getIpDetails(address).pipe(catchError(() => of(null as IpDetailsDto | null))),
      localIp: from(this.localIp.discoverLocalIpv4()).pipe(catchError(() => of(null as string | null))),
    }).pipe(
      map(({ details, localIp }) => ({
        address,
        notedAtClient: new Date().toISOString(),
        clientTimezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
        localIpAddress: localIp ?? undefined,
        deviceInfo: deviceDto,
        ipSnapshot: details ?? undefined,
      }))
    );
  }
}
