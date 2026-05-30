import { Component, OnInit, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { AdminService, AdminDashboardDto, AdminRoleDto } from './admin.service';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-admin-dashboard',
  templateUrl: './admin-dashboard.component.html',
  styleUrls: ['./admin-dashboard.component.scss'],
})
export class AdminDashboardComponent implements OnInit {
  private readonly admin = inject(AdminService);
  readonly i18n = inject(I18nService);

  loading = signal(true);
  error = signal<string | null>(null);
  stats = signal<AdminDashboardDto | null>(null);
  roles = signal<AdminRoleDto[]>([]);

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.error.set(null);
    this.admin.getDashboard().subscribe({
      next: (data) => {
        this.stats.set(data);
        this.loading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });

    this.admin.getRoles().subscribe({
      next: (data) => this.roles.set(data),
      error: () => undefined,
    });
  }
}
