import { Component, ChangeDetectorRef, inject } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { AuthService } from '../auth.service';
import { firstValueFrom } from 'rxjs';
import { I18nService } from 'src/app/core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-login',
  templateUrl: './login.component.html'
})
export class LoginComponent {
  readonly i18n = inject(I18nService);
  email = '';
  password = '';
  rememberMe = true;
  invalid = false;

  constructor(
    private authService: AuthService,
    private router: Router,
    private route: ActivatedRoute,
    private cdr: ChangeDetectorRef
  ) {}

  async login() {
    this.invalid = false;
    try {
      await firstValueFrom(this.authService.login(this.email, this.password, this.rememberMe));
      const returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/dashboard';
      await this.router.navigateByUrl(returnUrl);
    } catch {
      this.invalid = true;
      this.cdr.detectChanges();
    }
  }
}
