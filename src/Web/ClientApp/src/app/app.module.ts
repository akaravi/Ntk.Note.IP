import { APP_ID, NgModule, inject, provideAppInitializer } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { LucideAngularModule, Sun, Moon, Laptop, Plus, Settings, MoreHorizontal, Menu, X } from 'lucide-angular';
import { HTTP_INTERCEPTORS, provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';

import { AppComponent } from './app.component';
import { NavMenuComponent } from './nav-menu/nav-menu.component';
import { HomeComponent } from './home/home.component';
import { ThemeToggleComponent } from './theme-toggle/theme-toggle.component';
import { API_BASE_URL } from './web-api-client';
import { AuthorizeInterceptor } from 'src/api-authorization/authorize.interceptor';
import { LoginComponent } from 'src/api-authorization/login/login.component';
import { RegisterComponent } from 'src/api-authorization/register/register.component';
import { AuthGuard } from 'src/api-authorization/auth.guard';
import { AuthService } from 'src/api-authorization/auth.service';
import { IpLookupComponent } from './ip-lookup/ip-lookup.component';
import { IpNotesComponent } from './ip-notes/ip-notes.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { ToolsComponent } from './tools/tools.component';
import { I18nService } from './core/i18n.service';
import { AdminLayoutComponent } from './admin/admin-layout.component';
import { AdminDashboardComponent } from './admin/admin-dashboard.component';
import { AdminUsersComponent } from './admin/admin-users.component';
import { AdminIpNotesComponent } from './admin/admin-ip-notes.component';
import { AdminIpLookupsComponent } from './admin/admin-ip-lookups.component';
import { AdminPushComponent } from './admin/admin-push.component';
import { AdminOutboxComponent } from './admin/admin-outbox.component';
import { AdminRolesComponent } from './admin/admin-roles.component';
import { AdminGuard } from './admin/admin.guard';
import { AboutComponent } from './about/about.component';
import { CopyrightComponent } from './copyright/copyright.component';
import { ContactComponent } from './contact/contact.component';
import { AdminTicketsComponent } from './admin/admin-tickets.component';
import { PwaService } from './core/pwa.service';

export function getApiBaseUrl(): string {
  const url = document.getElementsByTagName('base')[0].href;
  return url.endsWith('/') ? url.slice(0, -1) : url;
}

@NgModule({
    declarations: [
        AppComponent,
        NavMenuComponent,
        HomeComponent,
        ThemeToggleComponent,
        LoginComponent,
        RegisterComponent,
        IpLookupComponent,
        IpNotesComponent,
        DashboardComponent,
        ToolsComponent,
        AdminLayoutComponent,
        AdminDashboardComponent,
        AdminUsersComponent,
        AdminIpNotesComponent,
        AdminIpLookupsComponent,
        AdminPushComponent,
        AdminOutboxComponent,
        AdminRolesComponent,
        AdminTicketsComponent,
        AboutComponent,
        CopyrightComponent,
        ContactComponent
    ],
    bootstrap: [AppComponent],
    imports: [
        BrowserModule,
        FormsModule,
        LucideAngularModule.pick({ Sun, Moon, Laptop, Plus, Settings, MoreHorizontal, Menu, X }),
        RouterModule.forRoot([
            { path: '', pathMatch: 'full', redirectTo: 'ip-lookup' },
            { path: 'home', component: HomeComponent },
            { path: 'ip-lookup', component: IpLookupComponent },
            { path: 'tools', component: ToolsComponent },
            { path: 'ip-notes', component: IpNotesComponent, canActivate: [AuthGuard] },
            { path: 'dashboard', component: DashboardComponent, canActivate: [AuthGuard] },
            { path: 'login', component: LoginComponent },
            { path: 'register', component: RegisterComponent },
            { path: 'about', component: AboutComponent },
            { path: 'contact', component: ContactComponent },
            { path: 'copyright', component: CopyrightComponent },
            {
                path: 'admin',
                component: AdminLayoutComponent,
                canActivate: [AuthGuard, AdminGuard],
                children: [
                    { path: '', pathMatch: 'full', redirectTo: 'dashboard' },
                    { path: 'dashboard', component: AdminDashboardComponent },
                    { path: 'roles', component: AdminRolesComponent },
                    { path: 'users', component: AdminUsersComponent },
                    { path: 'ip-notes', component: AdminIpNotesComponent },
                    { path: 'ip-lookups', component: AdminIpLookupsComponent },
                    { path: 'push', component: AdminPushComponent },
                    { path: 'outbox', component: AdminOutboxComponent },
                    { path: 'tickets', component: AdminTicketsComponent },
                ],
            },
        ])
    ],
    providers: [
        { provide: APP_ID, useValue: 'ng-cli-universal' },
        { provide: HTTP_INTERCEPTORS, useClass: AuthorizeInterceptor, multi: true },
        { provide: API_BASE_URL, useFactory: getApiBaseUrl, deps: [] },
        provideAppInitializer(() => inject(AuthService).initialize()),
        provideAppInitializer(() => {
          const i18n = inject(I18nService);
          return i18n.load(i18n.getStoredLocale());
        }),
        provideAppInitializer(() => {
          inject(PwaService).registerServiceWorker();
        }),
        provideHttpClient(withInterceptorsFromDi())
    ]
})
export class AppModule { }
