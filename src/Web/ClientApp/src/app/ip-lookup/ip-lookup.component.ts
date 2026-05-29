import { Component, OnDestroy, OnInit, inject, signal } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { CODE_SNIPPET_TABS, CodeSnippetTabId } from './code-snippet-samples';
import { CURL_COMMAND_TABS, CurlCommandTabId } from './curl-command-snippets';
import { IpHistorySyncService } from '../core/ip-history-sync.service';
import { AuthService } from 'src/api-authorization/auth.service';
import { distinctUntilChanged, filter, switchMap, take } from 'rxjs';
import { DeviceInfoService } from '../core/device-info.service';
import { IpHistoryEntry, IpHistoryService } from '../core/ip-history.service';
import { API_BASE_URL } from '../web-api-client';
import { apiV1Group } from '../core/api-routes';
import {
  DnsPropagationResultDto,
  DnsResolveResultDto,
  DnsService,
} from '../dns/dns.service';
import {
  BlacklistHitDto,
  IpToolsService,
  PrivacyFlagsDto,
  SubnetInfoDto,
  PortCheckResultDto,
  SslCertificateInfoDto,
  WhoisDomainDto,
  WhoisIpDto,
} from '../ip-tools/ip-tools.service';
import { I18nService } from '../core/i18n.service';
import { LocalIpService } from '../core/local-ip.service';
import { QrCodeService } from '../core/qr-code.service';
import { IpDetailsDto, IpLookupService, MyIpDto } from './ip-lookup.service';

@Component({
  standalone: false,
  selector: 'app-ip-lookup',
  templateUrl: './ip-lookup.component.html',
  styleUrls: ['./ip-lookup.component.scss'],
})
export class IpLookupComponent implements OnInit, OnDestroy {
  private readonly ipLookup = inject(IpLookupService);
  private readonly dnsService = inject(DnsService);
  private readonly ipTools = inject(IpToolsService);
  private readonly localIp = inject(LocalIpService);
  private readonly qrCode = inject(QrCodeService);
  private readonly ipHistory = inject(IpHistoryService);
  private readonly historySync = inject(IpHistorySyncService);
  private readonly authService = inject(AuthService);
  private readonly deviceInfo = inject(DeviceInfoService);
  private readonly apiBaseUrl = inject(API_BASE_URL);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  readonly i18n = inject(I18nService);

  readonly curlTabs = CURL_COMMAND_TABS;
  readonly codeTabs = CODE_SNIPPET_TABS;
  readonly device = this.deviceInfo.getSummary();
  private liveIpTimer: ReturnType<typeof setInterval> | null = null;

  address = signal('');
  domain = signal('example.com');
  cidr = signal('192.168.0.0/24');
  myIp = signal<MyIpDto | null>(null);
  details = signal<IpDetailsDto | null>(null);
  dnsResult = signal<DnsResolveResultDto | null>(null);
  propagation = signal<DnsPropagationResultDto | null>(null);
  propagationType = signal('A');
  whois = signal<WhoisIpDto | null>(null);
  whoisDomain = signal<WhoisDomainDto | null>(null);
  portCheck = signal<PortCheckResultDto | null>(null);
  sslCert = signal<SslCertificateInfoDto | null>(null);
  checkPort = signal(443);
  blacklist = signal<BlacklistHitDto[] | null>(null);
  privacy = signal<PrivacyFlagsDto | null>(null);
  subnet = signal<SubnetInfoDto | null>(null);
  loading = signal(false);
  dnsLoading = signal(false);
  propagationLoading = signal(false);
  toolsLoading = signal(false);
  error = signal<string | null>(null);
  plainCopied = signal(false);
  addressCopied = signal(false);
  localIpAddress = signal<string | null>(null);
  qrDataUrl = signal<string | null>(null);
  showQr = signal(false);
  historyEntries = signal<IpHistoryEntry[]>([]);
  activeCurlTab = signal<CurlCommandTabId>('linux');
  activeCodeTab = signal<CodeSnippetTabId>('csharp');
  curlCopied = signal(false);
  codeCopied = signal(false);
  historySyncing = signal(false);
  detailsLoading = signal(false);

  ngOnInit(): void {
    this.refreshHistory();
    this.loadMyIp();
    this.discoverLocalIp();
    const addressParam = this.route.snapshot.queryParamMap.get('address');
    if (addressParam?.trim()) {
      this.address.set(addressParam.trim());
      this.lookup();
    }

    this.scrollToToolFocus();
    this.startLiveIpWatch();
    this.authService.isAuthenticated$
      .pipe(
        distinctUntilChanged(),
        filter((isAuth) => isAuth),
        switchMap(() => {
          this.historySyncing.set(true);
          return this.historySync.syncAfterAuthentication();
        })
      )
      .subscribe({
        next: () => {
          this.refreshHistory();
          this.historySyncing.set(false);
        },
        error: () => this.historySyncing.set(false),
      });
  }

  ngOnDestroy(): void {
    if (this.liveIpTimer) {
      clearInterval(this.liveIpTimer);
    }
  }

  plainIpUrl(): string {
    const base = this.apiBaseUrl.replace(/\/$/, '');
    return `${base}${apiV1Group('IpLookup')}/GetMyIpPlain`;
  }

  activeCurlCommand(): string {
    const tab = this.curlTabs.find((t) => t.id === this.activeCurlTab()) ?? this.curlTabs[0];
    return tab.build(this.plainIpUrl());
  }

  copyCurlCommand(): void {
    void navigator.clipboard.writeText(this.activeCurlCommand());
    this.curlCopied.set(true);
    setTimeout(() => this.curlCopied.set(false), 2000);
  }

  activeCodeSnippet(): string {
    const tab = this.codeTabs.find((t) => t.id === this.activeCodeTab()) ?? this.codeTabs[0];
    return tab.build(this.plainIpUrl());
  }

  copyCodeSnippet(): void {
    void navigator.clipboard.writeText(this.activeCodeSnippet());
    this.codeCopied.set(true);
    setTimeout(() => this.codeCopied.set(false), 2000);
  }

  mapStaticUrl(lat: number, lon: number): string {
    return `https://staticmap.openstreetmap.de/staticmap.php?center=${lat},${lon}&zoom=10&size=640x280&markers=${lat},${lon},red`;
  }

  mapOpenUrl(lat: number, lon: number): string {
    return `https://www.openstreetmap.org/?mlat=${lat}&mlon=${lon}#map=12/${lat}/${lon}`;
  }

  refreshHistory(): void {
    this.historyEntries.set(this.ipHistory.getEntries());
  }

  selectHistoryEntry(entry: IpHistoryEntry): void {
    this.address.set(entry.address);
    this.lookup();
  }

  removeHistoryEntry(id: string, event: Event): void {
    event.stopPropagation();
    this.ipHistory.remove(id);
    this.refreshHistory();
  }

  clearHistory(): void {
    this.ipHistory.clear();
    this.refreshHistory();
  }

  formatHistoryWhen(iso: string): string {
    try {
      return new Intl.DateTimeFormat(this.i18n.locale(), {
        dateStyle: 'short',
        timeStyle: 'short',
      }).format(new Date(iso));
    } catch {
      return iso;
    }
  }

  private startLiveIpWatch(): void {
    this.liveIpTimer = setInterval(() => {
      this.ipLookup.getMyIp().subscribe({
        next: (data) => {
          const current = this.myIp()?.address;
          if (current && current !== data.address) {
            this.myIp.set(data);
            this.address.set(data.address);
            this.loadDetailsForAddress(data.address, true);
          }
        },
      });
    }, 60_000);
  }

  private recordHistoryFromDetails(details: IpDetailsDto): void {
    this.ipHistory.add({
      address: details.address,
      isIPv6: details.isIPv6,
      scope: details.scope,
      city: details.geo.city,
      countryCode: details.geo.countryCode,
      deviceLabel: this.device.label,
    });
    this.refreshHistory();
  }

  private scrollToToolFocus(): void {
    const focus = this.route.snapshot.queryParamMap.get('focus');
    if (!focus) {
      return;
    }

    setTimeout(() => {
      document.getElementById(`ip-tool-${focus}`)?.scrollIntoView({
        behavior: 'smooth',
        block: 'start',
      });
    }, 150);
  }

  private loadDetailsForAddress(address: string, recordHistory: boolean): void {
    this.detailsLoading.set(true);
    this.ipLookup.getIpDetails(address).subscribe({
      next: (data) => {
        this.details.set(data);
        this.detailsLoading.set(false);
        if (recordHistory) {
          this.recordHistoryFromDetails(data);
        }
      },
      error: () => this.detailsLoading.set(false),
    });
  }

  copyAddress(): void {
    const ip = this.myIp()?.address;
    if (!ip) {
      return;
    }

    void navigator.clipboard.writeText(ip);
    this.addressCopied.set(true);
    setTimeout(() => this.addressCopied.set(false), 2000);
  }

  noteThisIp(): void {
    const ip = this.myIp()?.address?.trim();
    if (!ip) {
      return;
    }

    const queryParams = { address: ip, capture: '1' };
    this.authService.isAuthenticated$.pipe(take(1)).subscribe((isAuth) => {
      if (isAuth) {
        void this.router.navigate(['/ip-notes'], { queryParams });
        return;
      }

      const returnUrl = `/ip-notes?address=${encodeURIComponent(ip)}&capture=1`;
      void this.router.navigate(['/login'], { queryParams: { returnUrl } });
    });
  }

  async toggleQr(): Promise<void> {
    const ip = this.myIp()?.address;
    if (!ip) {
      return;
    }

    if (this.showQr()) {
      this.showQr.set(false);
      return;
    }

    try {
      const url = await this.qrCode.toDataUrl(ip);
      this.qrDataUrl.set(url);
      this.showQr.set(true);
    } catch (err) {
      this.error.set(err instanceof Error ? err.message : String(err));
    }
  }

  discoverLocalIp(): void {
    this.localIpAddress.set(null);
    this.localIp.discoverLocalIpv4().then((ip) => this.localIpAddress.set(ip));
  }

  copyPlainIp(): void {
    this.ipLookup.getMyIpPlain().subscribe({
      next: (text) => {
        void navigator.clipboard.writeText(text.trim());
        this.plainCopied.set(true);
        setTimeout(() => this.plainCopied.set(false), 2000);
      },
      error: (err: Error) => this.error.set(err.message),
    });
  }

  loadMyIp(): void {
    this.loading.set(true);
    this.error.set(null);
    this.ipLookup.getMyIp().subscribe({
      next: (data) => {
        this.myIp.set(data);
        this.address.set(data.address);
        this.showQr.set(false);
        this.qrDataUrl.set(null);
        this.loading.set(false);
        this.loadDetailsForAddress(data.address, true);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });
  }

  lookup(): void {
    const value = this.address().trim();
    if (!value) {
      return;
    }

    this.loading.set(true);
    this.error.set(null);
    this.details.set(null);

    this.ipLookup.getIpDetails(value).subscribe({
      next: (data) => {
        this.details.set(data);
        this.recordHistoryFromDetails(data);
        this.loading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });
  }

  runTools(): void {
    const value = this.address().trim();
    if (!value) {
      return;
    }

    this.toolsLoading.set(true);
    this.error.set(null);
    this.whois.set(null);
    this.blacklist.set(null);
    this.privacy.set(null);

    this.ipTools.getWhoisIp(value).subscribe({
      next: (data) => this.whois.set(data),
      error: (err: Error) => this.error.set(err.message),
    });

    this.ipTools.getListBlacklist(value).subscribe({
      next: (data) => this.blacklist.set(data),
      error: (err: Error) => this.error.set(err.message),
    });

    this.ipTools.getPrivacyFlags(value).subscribe({
      next: (data) => {
        this.privacy.set(data);
        this.toolsLoading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.toolsLoading.set(false);
      },
    });
  }

  loadDomainWhois(): void {
    const value = this.domain().trim();
    if (!value) {
      return;
    }

    this.toolsLoading.set(true);
    this.ipTools.getWhoisDomain(value).subscribe({
      next: (data) => {
        this.whoisDomain.set(data);
        this.toolsLoading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.toolsLoading.set(false);
      },
    });
  }

  checkPortOpen(): void {
    const host = this.address().trim() || this.domain().trim();
    if (!host) {
      return;
    }

    this.toolsLoading.set(true);
    this.ipTools.checkPort(host, this.checkPort()).subscribe({
      next: (data) => {
        this.portCheck.set(data);
        this.toolsLoading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.toolsLoading.set(false);
      },
    });
  }

  loadSslCert(): void {
    const value = this.domain().trim();
    if (!value) {
      return;
    }

    this.toolsLoading.set(true);
    this.ipTools.getSslCertificate(value).subscribe({
      next: (data) => {
        this.sslCert.set(data);
        this.toolsLoading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.toolsLoading.set(false);
      },
    });
  }

  calculateSubnet(): void {
    const value = this.cidr().trim();
    if (!value) {
      return;
    }

    this.toolsLoading.set(true);
    this.ipTools.calculateSubnet(value).subscribe({
      next: (data) => {
        this.subnet.set(data);
        this.toolsLoading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.toolsLoading.set(false);
      },
    });
  }

  resolveDns(): void {
    const value = this.domain().trim();
    if (!value) {
      return;
    }

    this.dnsLoading.set(true);
    this.error.set(null);
    this.dnsResult.set(null);

    this.dnsService.resolveDns(value).subscribe({
      next: (data) => {
        this.dnsResult.set(data);
        this.dnsLoading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.dnsLoading.set(false);
      },
    });
  }

  checkPropagation(): void {
    const value = this.domain().trim();
    if (!value) {
      return;
    }

    this.propagationLoading.set(true);
    this.error.set(null);
    this.propagation.set(null);

    this.dnsService.getListDnsPropagation(value, this.propagationType()).subscribe({
      next: (data) => {
        this.propagation.set(data);
        this.propagationLoading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.propagationLoading.set(false);
      },
    });
  }
}
