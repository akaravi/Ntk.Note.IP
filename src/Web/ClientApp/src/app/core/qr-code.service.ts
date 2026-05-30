import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class QrCodeService {
  async toDataUrl(text: string): Promise<string> {
    const qrModule = await import('qrcode');
    const qr = (qrModule as unknown as { default?: typeof qrModule }).default ?? qrModule;
    const dark = this.resolveTokenColor('color', '--ip-qr-module', '#0f172a');
    const light = this.resolveTokenColor('backgroundColor', '--ip-qr-bg', '#ffffff');

    return qr.toDataURL(text, {
      margin: 1,
      width: 220,
      color: { dark, light },
    });
  }

  /** Resolves a CSS custom property to a computed rgb/rgba/hex string. */
  private resolveTokenColor(
    property: 'color' | 'backgroundColor',
    token: string,
    fallback: string,
  ): string {
    if (typeof document === 'undefined') {
      return fallback;
    }

    const probe = document.createElement('div');
    probe.style.setProperty(property, `var(${token})`);
    probe.style.display = 'none';
    document.documentElement.appendChild(probe);
    const resolved = getComputedStyle(probe)[property];
    probe.remove();

    return resolved && resolved !== 'rgba(0, 0, 0, 0)' ? resolved : fallback;
  }
}
