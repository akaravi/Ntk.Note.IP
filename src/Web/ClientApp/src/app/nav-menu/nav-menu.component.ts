import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from 'src/api-authorization/auth.service';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-nav-menu',
  templateUrl: './nav-menu.component.html',
  styleUrls: ['./nav-menu.component.scss']
})
export class NavMenuComponent {
  readonly i18n = inject(I18nService);
  isAuthenticated$ = this.authService.isAuthenticated$;

  constructor(private authService: AuthService, private router: Router) {}

  toggleLanguage(): void {
    void this.i18n.toggleLocale();
  }

  logout(event: Event): void {
    event.preventDefault();
    this.authService.logout().subscribe({
      next: () => this.router.navigate(['/login'])
    });
  }
}
