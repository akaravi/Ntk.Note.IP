import { Injectable } from '@angular/core';

export const IP_HISTORY_SCHEMA_VERSION = 1;
const STORAGE_KEY = 'ipnote.ip-history';
const MAX_ENTRIES = 50;

export interface IpHistoryEntry {
  id: string;
  address: string;
  isIPv6: boolean;
  scope?: string;
  recordedAt: string;
  city?: string;
  countryCode?: string;
  deviceLabel?: string;
}

interface IpHistoryStore {
  version: number;
  entries: IpHistoryEntry[];
}

@Injectable({ providedIn: 'root' })
export class IpHistoryService {
  getEntries(): IpHistoryEntry[] {
    return this.readStore().entries;
  }

  add(entry: Omit<IpHistoryEntry, 'id' | 'recordedAt'> & { recordedAt?: string }): void {
    const store = this.readStore();
    const recordedAt = entry.recordedAt ?? new Date().toISOString();
    const normalized: IpHistoryEntry = {
      id: crypto.randomUUID(),
      address: entry.address,
      isIPv6: entry.isIPv6,
      scope: entry.scope,
      recordedAt,
      city: entry.city,
      countryCode: entry.countryCode,
      deviceLabel: entry.deviceLabel,
    };

    const withoutDup = store.entries.filter((e) => e.address !== normalized.address);
    const entries = [normalized, ...withoutDup].slice(0, MAX_ENTRIES);
    this.writeStore({ version: IP_HISTORY_SCHEMA_VERSION, entries });
  }

  remove(id: string): void {
    const store = this.readStore();
    this.writeStore({
      version: IP_HISTORY_SCHEMA_VERSION,
      entries: store.entries.filter((e) => e.id !== id),
    });
  }

  clear(): void {
    this.writeStore({ version: IP_HISTORY_SCHEMA_VERSION, entries: [] });
  }

  private readStore(): IpHistoryStore {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      if (!raw) {
        return { version: IP_HISTORY_SCHEMA_VERSION, entries: [] };
      }

      const parsed = JSON.parse(raw) as IpHistoryStore;
      if (parsed.version !== IP_HISTORY_SCHEMA_VERSION || !Array.isArray(parsed.entries)) {
        return { version: IP_HISTORY_SCHEMA_VERSION, entries: [] };
      }

      return parsed;
    } catch {
      return { version: IP_HISTORY_SCHEMA_VERSION, entries: [] };
    }
  }

  private writeStore(store: IpHistoryStore): void {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(store));
  }
}
