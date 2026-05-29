import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class PwaService {
  registerServiceWorker(): void {
    if (!('serviceWorker' in navigator)) {
      return;
    }

    void navigator.serviceWorker.register('/sw.js').catch(() => {
      // Optional PWA shell; ignore registration failures in dev.
    });
  }
}
