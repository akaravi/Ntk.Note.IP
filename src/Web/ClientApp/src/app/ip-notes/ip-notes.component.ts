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

  formatWhen(iso?: string): string {
    if (!iso) {
      return '—';
    }

    try {
      return new Intl.DateTimeFormat(this.i18n.locale(), {
        dateStyle: 'short',
        timeStyle: 'short',
      }).format(new Date(iso));
    } catch {
      return iso;
    }
  }

  noteWhen(note: IpNoteDto): string {
    return this.formatWhen(note.notedAtClient ?? note.created);
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
