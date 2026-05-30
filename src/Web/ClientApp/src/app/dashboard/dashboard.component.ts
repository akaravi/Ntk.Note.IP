import { Component, OnInit, computed, inject, signal } from '@angular/core';
import { Router } from '@angular/router';
import { forkJoin, of } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { I18nService } from '../core/i18n.service';
import { IpHistoryService } from '../core/ip-history.service';
import { IpLookupService } from '../ip-lookup/ip-lookup.service';
import { IpNotesService } from '../ip-notes/ip-notes.service';
import { API_BASE_URL } from '../web-api-client';
import { buildAggregateMapUrl } from './dashboard-map';
import {
  buildDashboardTimeline,
  computeCountryBreakdown,
  computeDashboardStats,
  DashboardTimelineItem,
  filterTimeline,
} from './dashboard-timeline';

@Component({
  standalone: false,
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss'],
})
export class DashboardComponent implements OnInit {
  private readonly ipHistory = inject(IpHistoryService);
  private readonly ipLookup = inject(IpLookupService);
  private readonly ipNotes = inject(IpNotesService);
  private readonly router = inject(Router);
  private readonly apiBaseUrl = inject(API_BASE_URL);
  readonly i18n = inject(I18nService);

  loading = signal(true);
  error = signal<string | null>(null);
  allItems = signal<DashboardTimelineItem[]>([]);
  search = signal('');
  countryFilter = signal('');
  mapLoading = signal(false);
  mapUrl = signal<string | null>(null);

  filteredItems = computed(() =>
    filterTimeline(this.allItems(), this.search(), this.countryFilter())
  );

  stats = computed(() => computeDashboardStats(this.filteredItems()));

  countryBreakdown = computed(() => computeCountryBreakdown(this.filteredItems()));

  countryOptions = computed(() => {
    const codes = new Set<string>();
    for (const item of this.allItems()) {
      if (item.countryCode) {
        codes.add(item.countryCode.toUpperCase());
      }
    }
    return [...codes].sort();
  });

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.error.set(null);

    const local = this.ipHistory.getEntries();

    forkJoin({
      server: this.ipLookup.getListIpLookupRecords().pipe(catchError(() => of([]))),
      notes: this.ipNotes.getList().pipe(catchError(() => of([]))),
    }).subscribe({
      next: ({ server, notes }) => {
        const items = buildDashboardTimeline(local, server, notes);
        this.allItems.set(items);
        this.loading.set(false);
        this.loadAggregateMap(items);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });
  }

  formatWhen(iso: string): string {
    try {
      return new Intl.DateTimeFormat(this.i18n.locale(), {
        dateStyle: 'medium',
        timeStyle: 'short',
      }).format(new Date(iso));
    } catch {
      return iso;
    }
  }

  openLookup(item: DashboardTimelineItem): void {
    void this.router.navigate(['/ip-lookup'], {
      queryParams: { address: item.address },
    });
  }

  openNotes(): void {
    void this.router.navigate(['/ip-notes']);
  }

  filterByCountry(code: string): void {
    this.countryFilter.set(this.countryFilter() === code ? '' : code);
  }

  private loadAggregateMap(items: DashboardTimelineItem[]): void {
    const addresses = [
      ...new Set(
        items.filter((item) => item.kind === 'lookup').map((item) => item.address)
      ),
    ].slice(0, 12);

    if (addresses.length === 0) {
      this.mapUrl.set(null);
      return;
    }

    this.mapLoading.set(true);
    forkJoin(
      addresses.map((address) =>
        this.ipLookup.getIpDetails(address).pipe(catchError(() => of(null)))
      )
    ).subscribe({
      next: (results) => {
        const markers = results
          .filter((details) => details?.geo.latitude != null && details.geo.longitude != null)
          .map((details) => ({
            lat: details!.geo.latitude!,
            lon: details!.geo.longitude!,
          }));
        this.mapUrl.set(buildAggregateMapUrl(this.apiBaseUrl, markers));
        this.mapLoading.set(false);
      },
      error: () => {
        this.mapUrl.set(null);
        this.mapLoading.set(false);
      },
    });
  }

  exportJson(): void {
    this.downloadFile(
      JSON.stringify(this.filteredItems(), null, 2),
      'ipnote-dashboard.json',
      'application/json'
    );
  }

  exportCsv(): void {
    const header = 'kind,address,recordedAt,city,countryCode,deviceLabel,title,tags';
    const rows = this.filteredItems().map((item) =>
      [
        item.kind,
        item.address,
        item.recordedAt,
        item.city ?? '',
        item.countryCode ?? '',
        item.deviceLabel ?? '',
        item.title ?? '',
        item.tags ?? '',
      ]
        .map((value) => `"${String(value).replace(/"/g, '""')}"`)
        .join(',')
    );
    this.downloadFile([header, ...rows].join('\n'), 'ipnote-dashboard.csv', 'text/csv');
  }

  private downloadFile(content: string, filename: string, mime: string): void {
    const blob = new Blob([content], { type: mime });
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = filename;
    anchor.click();
    URL.revokeObjectURL(url);
  }
}
