import { Component, OnInit, inject, signal } from '@angular/core';
import { AdminService, AdminSupportTicketDto } from './admin.service';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-admin-tickets',
  templateUrl: './admin-tickets.component.html',
})
export class AdminTicketsComponent implements OnInit {
  private readonly admin = inject(AdminService);
  readonly i18n = inject(I18nService);

  loading = signal(true);
  error = signal<string | null>(null);
  tickets = signal<AdminSupportTicketDto[]>([]);
  openOnly = true;

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.error.set(null);
    this.admin.getSupportTickets(this.openOnly).subscribe({
      next: (data) => {
        this.tickets.set(data);
        this.loading.set(false);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });
  }

  closeTicket(ticket: AdminSupportTicketDto): void {
    this.admin.updateSupportTicketStatus(ticket.id, 'Closed').subscribe({
      next: () => this.load(),
      error: (err: Error) => this.error.set(err.message),
    });
  }

  reopenTicket(ticket: AdminSupportTicketDto): void {
    this.admin.updateSupportTicketStatus(ticket.id, 'Open').subscribe({
      next: () => this.load(),
      error: (err: Error) => this.error.set(err.message),
    });
  }
}
