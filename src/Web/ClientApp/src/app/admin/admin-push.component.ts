import { Component, OnInit, inject, signal } from '@angular/core';
import { AdminService, AdminPushDeviceDto } from './admin.service';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-admin-push',
  templateUrl: './admin-push.component.html',
})
export class AdminPushComponent implements OnInit {
  private readonly admin = inject(AdminService);
  readonly i18n = inject(I18nService);

  loading = signal(true);
  error = signal<string | null>(null);
  devices = signal<AdminPushDeviceDto[]>([]);

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.error.set(null);
    this.admin.getPushDevices().subscribe({
      next: (data) => {
        this.devices.set(data);
        this.loading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });
  }

  deleteDevice(id: number): void {
    if (!confirm(this.i18n.t('ADMIN.CONFIRM_DELETE'))) {
      return;
    }
    this.admin.deletePushDevice(id).subscribe({
      next: () => this.load(),
      error: (err: Error) => this.error.set(err.message),
    });
  }

  tokenPreview(token: string): string {
    if (token.length <= 24) {
      return token;
    }
    return `${token.slice(0, 12)}…${token.slice(-8)}`;
  }
}
