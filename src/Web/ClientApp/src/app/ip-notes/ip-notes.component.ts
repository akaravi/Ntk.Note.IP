import { Component, OnInit, inject, signal } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { I18nService } from '../core/i18n.service';
import { IpNoteSnapshotBuilder } from '../core/ip-note-snapshot.builder';
import { IpLookupService } from '../ip-lookup/ip-lookup.service';
import { AddIpNoteCommand, IpNoteDto, IpNotesService } from './ip-notes.service';

@Component({
  standalone: false,
  selector: 'app-ip-notes',
  templateUrl: './ip-notes.component.html',
  styleUrls: ['./ip-notes.component.scss'],
})
export class IpNotesComponent implements OnInit {
  private readonly notesService = inject(IpNotesService);
  private readonly ipLookup = inject(IpLookupService);
  private readonly snapshotBuilder = inject(IpNoteSnapshotBuilder);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  readonly i18n = inject(I18nService);

  notes = signal<IpNoteDto[]>([]);
  loading = signal(false);
  error = signal<string | null>(null);
  snapshotReady = signal(false);
  form: AddIpNoteCommand = { address: '', title: '', body: '', tags: '' };

  ngOnInit(): void {
    const addressParam = this.route.snapshot.queryParamMap.get('address');
    if (addressParam?.trim()) {
      this.form.address = addressParam.trim();
    }

    if (this.route.snapshot.queryParamMap.get('capture') === '1' && this.form.address.trim()) {
      this.captureSnapshot(this.form.address.trim());
    }

    this.reload();
  }

  private static readonly DAY_MS = 24 * 60 * 60 * 1000;

  private noteWhenIso(note: IpNoteDto): string | undefined {
    return note.notedAtClient ?? note.created;
  }

  /** Full, explicit date + time (weekday + full date + clock) for clarity. */
  formatWhen(iso?: string): string {
    if (!iso) {
      return '—';
    }

    try {
      return new Intl.DateTimeFormat(this.i18n.locale(), {
        dateStyle: 'full',
        timeStyle: 'short',
      }).format(new Date(iso));
    } catch {
      return iso;
    }
  }

  /** True when the note was captured within the last 24h. */
  isRecent(note: IpNoteDto): boolean {
    const iso = this.noteWhenIso(note);
    if (!iso) {
      return false;
    }

    const diff = Date.now() - new Date(iso).getTime();
    return diff >= 0 && diff < IpNotesComponent.DAY_MS;
  }

  /** Within a day -> relative ("3 hours ago"); otherwise the full date. */
  noteWhenPrimary(note: IpNoteDto): string {
    const iso = this.noteWhenIso(note);
    if (!iso) {
      return '—';
    }

    return this.isRecent(note) ? this.relativeWhen(iso) : this.formatWhen(iso);
  }

  /** Always the full, exact date + time (secondary line for recent notes). */
  noteWhenExact(note: IpNoteDto): string {
    return this.formatWhen(this.noteWhenIso(note));
  }

  private relativeWhen(iso: string): string {
    const diffMs = Date.now() - new Date(iso).getTime();

    if (diffMs < 60_000) {
      return this.i18n.t('IP.NOTE_JUST_NOW');
    }

    try {
      const rtf = new Intl.RelativeTimeFormat(this.i18n.locale(), { numeric: 'always' });
      if (diffMs < 3_600_000) {
        return rtf.format(-Math.floor(diffMs / 60_000), 'minute');
      }
      return rtf.format(-Math.floor(diffMs / 3_600_000), 'hour');
    } catch {
      return this.formatWhen(iso);
    }
  }

  deviceRows(note: IpNoteDto): Array<{ key: string; value: string }> {
    return this.buildDeviceRows(note.deviceInfo);
  }

  formDeviceRows(): Array<{ key: string; value: string }> {
    return this.buildDeviceRows(this.form.deviceInfo);
  }

  private buildDeviceRows(
    info?: { browser?: string; os?: string; deviceType?: string; language?: string }
  ): Array<{ key: string; value: string }> {
    if (!info) {
      return [];
    }

    return [
      { key: 'DEVICE.BROWSER', value: info.browser ?? '' },
      { key: 'DEVICE.OS', value: info.os ?? '' },
      { key: 'DEVICE.TYPE', value: info.deviceType ?? '' },
      { key: 'DEVICE.LANGUAGE', value: info.language ?? '' },
    ].filter((row) => row.value.trim().length > 0);
  }

  locationLine(note: IpNoteDto): string {
    const parts = [note.city, note.region, note.countryCode?.toUpperCase()].filter(Boolean);
    return parts.join(' · ');
  }

  tagList(tags?: string): string[] {
    if (!tags?.trim()) {
      return [];
    }

    return tags.split(',').map((t) => t.trim()).filter(Boolean);
  }

  fillMyIp(): void {
    this.ipLookup.getMyIp().subscribe({
      next: (data) => {
        this.form.address = data.address;
        this.captureSnapshot(data.address);
      },
      error: (err: Error) => this.error.set(err.message),
    });
  }

  openLookup(address: string): void {
    void this.router.navigate(['/ip-lookup'], { queryParams: { address } });
  }

  reload(): void {
    this.loading.set(true);
    this.error.set(null);
    this.notesService.getList().subscribe({
      next: (list) => {
        this.notes.set(list);
        this.loading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });
  }

  addNote(): void {
    if (!this.form.address.trim()) {
      return;
    }

    this.loading.set(true);
    this.error.set(null);
    this.notesService.add(this.form).subscribe({
      next: () => {
        this.form = { address: '', title: '', body: '', tags: '' };
        this.snapshotReady.set(false);
        this.reload();
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });
  }

  deleteNote(id: number): void {
    if (!confirm(this.i18n.t('IP.NOTE_DELETE_CONFIRM'))) {
      return;
    }

    this.loading.set(true);
    this.notesService.delete(id).subscribe({
      next: () => this.reload(),
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });
  }

  private captureSnapshot(address: string): void {
    this.snapshotReady.set(false);
    this.snapshotBuilder.buildForAddress(address).subscribe({
      next: (snapshot) => {
        this.form = {
          ...this.form,
          address,
          ...snapshot,
        };
        this.snapshotReady.set(true);
      },
      error: () => this.snapshotReady.set(false),
    });
  }
}
