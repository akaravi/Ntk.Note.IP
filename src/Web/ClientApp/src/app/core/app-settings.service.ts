import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';

export interface AppSettingsModel {
  ClientId: string;
  ApiBaseUrl: string;
  Secret: string;
}

@Injectable({ providedIn: 'root' })
export class AppSettingsService {
  private settings: AppSettingsModel | null = null;

  async load(): Promise<void> {
    const fileName = environment.production
      ? 'appsettings.Production.json'
      : 'appsettings.json';

    const response = await fetch(`/assets/${fileName}`, { cache: 'no-store' });
    if (!response.ok) {
      throw new Error(`Failed to load ${fileName}: ${response.status}`);
    }

    this.settings = (await response.json()) as AppSettingsModel;
  }

  get clientId(): string {
    return this.settings?.ClientId ?? 'panel-web';
  }

  get apiBaseUrlOverride(): string {
    return this.settings?.ApiBaseUrl?.trim() ?? '';
  }

  get clientSecret(): string {
    return this.settings?.Secret?.trim() ?? '';
  }
}
