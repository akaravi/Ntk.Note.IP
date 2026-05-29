import { IpHistoryEntry } from '../core/ip-history.service';
import { IpLookupRecordDto } from '../ip-lookup/ip-lookup.service';
import { IpNoteDto } from '../ip-notes/ip-notes.service';

export type DashboardTimelineKind = 'lookup' | 'note';

export interface DashboardTimelineItem {
  id: string;
  kind: DashboardTimelineKind;
  address: string;
  recordedAt: string;
  city?: string;
  countryCode?: string;
  deviceLabel?: string;
  title?: string;
  body?: string;
  tags?: string;
}

export function buildDashboardTimeline(
  localHistory: IpHistoryEntry[],
  serverRecords: IpLookupRecordDto[],
  notes: IpNoteDto[]
): DashboardTimelineItem[] {
  const lookupByAddress = new Map<string, DashboardTimelineItem>();

  const upsertLookup = (item: DashboardTimelineItem) => {
    const key = item.address.toLowerCase();
    const existing = lookupByAddress.get(key);
    if (!existing || item.recordedAt > existing.recordedAt) {
      lookupByAddress.set(key, item);
    }
  };

  for (const entry of localHistory) {
    upsertLookup({
      id: `local-${entry.id}`,
      kind: 'lookup',
      address: entry.address,
      recordedAt: entry.recordedAt,
      city: entry.city,
      countryCode: entry.countryCode,
      deviceLabel: entry.deviceLabel,
    });
  }

  for (const record of serverRecords) {
    upsertLookup({
      id: `server-${record.id}`,
      kind: 'lookup',
      address: record.address,
      recordedAt: record.created,
      city: record.city ?? undefined,
      countryCode: record.countryCode ?? undefined,
    });
  }

  const noteItems: DashboardTimelineItem[] = notes.map((note) => ({
    id: `note-${note.id}`,
    kind: 'note',
    address: note.address,
    recordedAt: note.created,
    title: note.title,
    body: note.body,
    tags: note.tags,
  }));

  return [...lookupByAddress.values(), ...noteItems].sort(
    (a, b) => Date.parse(b.recordedAt) - Date.parse(a.recordedAt)
  );
}

export function filterTimeline(
  items: DashboardTimelineItem[],
  search: string,
  countryCode: string
): DashboardTimelineItem[] {
  const query = search.trim().toLowerCase();
  return items.filter((item) => {
    if (countryCode && (item.countryCode ?? '').toUpperCase() !== countryCode.toUpperCase()) {
      return false;
    }

    if (!query) {
      return true;
    }

    const haystack = [
      item.address,
      item.city,
      item.countryCode,
      item.deviceLabel,
      item.title,
      item.body,
      item.tags,
    ]
      .filter(Boolean)
      .join(' ')
      .toLowerCase();

    return haystack.includes(query);
  });
}

export function computeDashboardStats(items: DashboardTimelineItem[]): {
  total: number;
  uniqueAddresses: number;
  uniqueCountries: number;
  noteCount: number;
} {
  const addresses = new Set<string>();
  const countries = new Set<string>();
  let noteCount = 0;

  for (const item of items) {
    addresses.add(item.address.toLowerCase());
    if (item.countryCode) {
      countries.add(item.countryCode.toUpperCase());
    }
    if (item.kind === 'note') {
      noteCount += 1;
    }
  }

  return {
    total: items.length,
    uniqueAddresses: addresses.size,
    uniqueCountries: countries.size,
    noteCount,
  };
}

export interface CountryCount {
  code: string;
  count: number;
}

export function computeCountryBreakdown(items: DashboardTimelineItem[]): CountryCount[] {
  const counts = new Map<string, number>();

  for (const item of items) {
    if (!item.countryCode) {
      continue;
    }

    const code = item.countryCode.toUpperCase();
    counts.set(code, (counts.get(code) ?? 0) + 1);
  }

  return [...counts.entries()]
    .map(([code, count]) => ({ code, count }))
    .sort((a, b) => b.count - a.count);
}
