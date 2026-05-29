import { Component, HostListener, OnDestroy, OnInit, inject, signal } from '@angular/core';
import { NavigationEnd, Router } from '@angular/router';
import { filter, Subscription } from 'rxjs';
import { AuthService } from 'src/api-authorization/auth.service';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-nav-menu',
  templateUrl: './nav-menu.component.html',
  styleUrls: ['./nav-menu.component.scss']
})
export class NavMenuComponent implements OnInit, OnDestroy {
  readonly i18n = inject(I18nService);
  readonly menuOpen = signal(false);
  isAuthenticated$ = this.authService.isAuthenticated$;
  isAdministrator$ = this.authService.isAdministrator$;

  private routerSub?: Subscription;

  constructor(private authService: AuthService, private router: Router) {}

  ngOnInit(): void {
    this.routerSub = this.router.events
      .pipe(filter((event) => event instanceof NavigationEnd))
      .subscribe(() => this.closeMenu());
  }

  ngOnDestroy(): void {
    this.routerSub?.unsubscribe();
    this.setMenuOpen(false);
  }

  @HostListener('document:keydown.escape')
  onEscape(): void {
    this.closeMenu();
  }

  toggleMenu(): void {
    this.setMenuOpen(!this.menuOpen());
  }

  closeMenu(): void {
    this.setMenuOpen(false);
  }

  onPanelClick(event: Event): void {
    const target = event.target as HTMLElement | null;
    if (target?.closest('a[routerLink], a[data-testid="nav-logout"]')) {
      this.closeMenu();
    }
  }

  toggleLanguage(): void {
    void this.i18n.toggleLocale();
  }

  logout(event: Event): void {
    event.preventDefault();
    this.closeMenu();
    this.authService.logout().subscribe({
      next: () => this.router.navigate(['/login'])
    });
  }

  private setMenuOpen(open: boolean): void {
    this.menuOpen.set(open);
    document.body.classList.toggle('nav-menu-open', open);
  }
}
