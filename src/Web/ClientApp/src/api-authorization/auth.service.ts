import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable, of } from 'rxjs';
import { tap, catchError, map, switchMap } from 'rxjs/operators';
import { LoginRequest, RegisterRequest, UsersClient } from '../app/web-api-client';
import { IpHistorySyncService } from '../app/core/ip-history-sync.service';
import { AdminService } from '../app/admin/admin.service';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private _isAuthenticated = new BehaviorSubject<boolean>(false);
  isAuthenticated$ = this._isAuthenticated.asObservable();

  private _isAdministrator = new BehaviorSubject<boolean>(false);
  isAdministrator$ = this._isAdministrator.asObservable();

  constructor(
    private usersClient: UsersClient,
    private historySync: IpHistorySyncService,
    private adminService: AdminService
  ) {}

  initialize(): Observable<boolean> {
    return this.usersClient.infoGET().pipe(
      map(() => true),
      catchError(() => of(false)),
      tap((isAuth) => this._isAuthenticated.next(isAuth)),
      switchMap((isAuth) =>
        isAuth
          ? this.refreshAdminAccess().pipe(map(() => isAuth))
          : this.clearAdminAccess().pipe(map(() => isAuth))
      ),
      switchMap((isAuth) =>
        isAuth
          ? this.historySync.syncAfterAuthentication().pipe(map(() => isAuth))
          : of(isAuth)
      )
    );
  }

  login(email: string, password: string): Observable<void> {
    return this.usersClient.login(true, undefined, new LoginRequest({ email, password })).pipe(
      tap(() => this._isAuthenticated.next(true)),
      switchMap(() => this.refreshAdminAccess()),
      switchMap(() => this.historySync.syncAfterAuthentication()),
      map(() => void 0)
    );
  }

  register(email: string, password: string): Observable<void> {
    return this.usersClient.register(new RegisterRequest({ email, password }));
  }

  logout(): Observable<void> {
    return this.usersClient.logout({}).pipe(
      tap(() => {
        this._isAuthenticated.next(false);
        this._isAdministrator.next(false);
        this.historySync.resetSession();
      })
    );
  }

  private refreshAdminAccess(): Observable<void> {
    return this.adminService.getAccess().pipe(
      tap((access) => this._isAdministrator.next(access.isAdministrator)),
      catchError(() => {
        this._isAdministrator.next(false);
        return of(undefined);
      }),
      map(() => void 0)
    );
  }

  private clearAdminAccess(): Observable<void> {
    this._isAdministrator.next(false);
    return of(undefined);
  }
}
