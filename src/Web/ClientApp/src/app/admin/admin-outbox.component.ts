import { Component, OnInit, inject, signal } from '@angular/core';
import { AdminService, AdminOutboxMessageDto } from './admin.service';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-admin-outbox',
  templateUrl: './admin-outbox.component.html',
})
export class AdminOutboxComponent implements OnInit {
  private readonly admin = inject(AdminService);
  readonly i18n = inject(I18nService);

  loading = signal(true);
  error = signal<string | null>(null);
  messages = signal<AdminOutboxMessageDto[]>([]);
  pendingOnly = false;

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.error.set(null);
    this.admin.getOutbox(this.pendingOnly).subscribe({
      next: (data) => {
        this.messages.set(data);
        this.loading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });
  }
}
