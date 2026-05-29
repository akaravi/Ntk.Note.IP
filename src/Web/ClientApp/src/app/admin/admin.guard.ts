import { inject, Injectable } from '@angular/core';
import { CanActivate, Router, UrlTree } from '@angular/router';
import { catchError, map, Observable, of } from 'rxjs';
import { AdminService } from './admin.service';

@Injectable({ providedIn: 'root' })
export class AdminGuard implements CanActivate {
  private readonly admin = inject(AdminService);
  private readonly router = inject(Router);

  canActivate(): Observable<boolean | UrlTree> {
    return this.admin.getAccess().pipe(
      map((access) => (access.isAdministrator ? true : this.router.createUrlTree(['/dashboard']))),
      catchError(() => of(this.router.createUrlTree(['/login'], { queryParams: { returnUrl: '/admin' } })))
    );
  }
}
