import { Component, OnInit, inject, signal } from '@angular/core';
import { AdminService, AdminUserDto } from './admin.service';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-admin-users',
  templateUrl: './admin-users.component.html',
})
export class AdminUsersComponent implements OnInit {
  private readonly admin = inject(AdminService);
  readonly i18n = inject(I18nService);

  loading = signal(true);
  error = signal<string | null>(null);
  users = signal<AdminUserDto[]>([]);
  editingUserId = signal<string | null>(null);
  roleDraftValue = '';

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.error.set(null);
    this.admin.getUsers().subscribe({
      next: (data) => {
        this.users.set(data);
        this.loading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });
  }

  startEdit(user: AdminUserDto): void {
    this.editingUserId.set(user.id);
    this.roleDraftValue = user.roles.join(', ');
  }

  cancelEdit(): void {
    this.editingUserId.set(null);
    this.roleDraftValue = '';
  }

  saveRoles(userId: string): void {
    const roles = this.roleDraftValue
      .split(',')
      .map((r) => r.trim())
      .filter(Boolean);
    this.admin.setUserRoles(userId, roles).subscribe({
      next: () => {
        this.cancelEdit();
        this.load();
      },
      error: (err: Error) => this.error.set(err.message),
    });
  }

  rolesLabel(user: AdminUserDto): string {
    return user.roles.length ? user.roles.join(', ') : '—';
  }
}
