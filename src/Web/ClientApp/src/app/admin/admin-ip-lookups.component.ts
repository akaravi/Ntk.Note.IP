import { Component, OnInit, inject, signal } from '@angular/core';
import { IpLookupRecordDto } from '../ip-lookup/ip-lookup.service';
import { AdminService } from './admin.service';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-admin-ip-lookups',
  templateUrl: './admin-ip-lookups.component.html',
})
export class AdminIpLookupsComponent implements OnInit {
  private readonly admin = inject(AdminService);
  readonly i18n = inject(I18nService);

  loading = signal(true);
  error = signal<string | null>(null);
  records = signal<IpLookupRecordDto[]>([]);
  search = '';

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.error.set(null);
    this.admin.getIpLookups(this.search).subscribe({
      next: (data) => {
        this.records.set(data);
        this.loading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });
  }

  deleteRecord(id: number): void {
    if (!confirm(this.i18n.t('ADMIN.CONFIRM_DELETE'))) {
      return;
    }
    this.admin.deleteIpLookup(id).subscribe({
      next: () => this.load(),
      error: (err: Error) => this.error.set(err.message),
    });
  }
}
