import { Injectable, signal } from '@angular/core';

const LOCALE_STORAGE_KEY = 'ipnote.locale';

@Injectable({ providedIn: 'root' })
export class I18nService {
  private labels: Record<string, string> = {};

  readonly locale = signal<'fa' | 'en'>('fa');
  readonly direction = signal<'rtl' | 'ltr'>('rtl');

  async load(locale = 'fa'): Promise<void> {
    const normalized = locale === 'en' ? 'en' : 'fa';
    const response = await fetch(`/assets/i18n/${normalized}.json`);
    const nested = await response.json();
    this.labels = this.flatten(nested);
    this.locale.set(normalized);
    this.direction.set(normalized === 'fa' ? 'rtl' : 'ltr');
    this.applyDocumentLanguage(normalized);
  }

  async setLocale(locale: 'fa' | 'en'): Promise<void> {
    localStorage.setItem(LOCALE_STORAGE_KEY, locale);
    await this.load(locale);
  }

  toggleLocale(): Promise<void> {
    return this.setLocale(this.locale() === 'fa' ? 'en' : 'fa');
  }

  getStoredLocale(): 'fa' | 'en' {
    return localStorage.getItem(LOCALE_STORAGE_KEY) === 'en' ? 'en' : 'fa';
  }

  t(key: string): string {
    return this.labels[key] ?? key;
  }

  private applyDocumentLanguage(locale: 'fa' | 'en'): void {
    document.documentElement.lang = locale;
    document.documentElement.dir = locale === 'fa' ? 'rtl' : 'ltr';
    document.body.classList.toggle('ip-locale-fa', locale === 'fa');
    document.body.classList.toggle('ip-locale-en', locale === 'en');
  }

  private flatten(node: Record<string, unknown>, prefix = ''): Record<string, string> {
    const result: Record<string, string> = {};
    for (const [name, value] of Object.entries(node)) {
      const path = prefix ? `${prefix}.${name}` : name;
      if (typeof value === 'string') {
        result[path] = value;
      } else if (value && typeof value === 'object') {
        Object.assign(result, this.flatten(value as Record<string, unknown>, path));
      }
    }
    return result;
  }
}
