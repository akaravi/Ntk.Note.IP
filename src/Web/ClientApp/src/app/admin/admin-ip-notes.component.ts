import { Component, OnInit, inject, signal } from '@angular/core';
import { AdminService, AdminIpNoteListItemDto } from './admin.service';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-admin-ip-notes',
  templateUrl: './admin-ip-notes.component.html',
})
export class AdminIpNotesComponent implements OnInit {
  private readonly admin = inject(AdminService);
  readonly i18n = inject(I18nService);

  loading = signal(true);
  error = signal<string | null>(null);
  notes = signal<AdminIpNoteListItemDto[]>([]);
  search = '';

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.error.set(null);
    this.admin.getIpNotes(this.search).subscribe({
      next: (data) => {
        this.notes.set(data);
        this.loading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });
  }

  deleteNote(id: number): void {
    if (!confirm(this.i18n.t('ADMIN.CONFIRM_DELETE'))) {
      return;
    }
    this.admin.deleteIpNote(id).subscribe({
      next: () => this.load(),
      error: (err: Error) => this.error.set(err.message),
    });
  }
}
