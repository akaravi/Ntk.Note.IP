import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class QrCodeService {
  async toDataUrl(text: string): Promise<string> {
    const QRCode = await import('qrcode');
    const dark = getComputedStyle(document.documentElement)
      .getPropertyValue('--ip-text')
      .trim() || '#1a1a2e';
    const light = getComputedStyle(document.documentElement)
      .getPropertyValue('--ip-surface')
      .trim() || '#ffffff';

    return QRCode.toDataURL(text, {
      margin: 1,
      width: 220,
      color: { dark, light },
    });
  }
}
