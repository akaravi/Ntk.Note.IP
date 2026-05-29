import { Injectable } from '@angular/core';

export interface DeviceInfoSummary {
  browser: string;
  os: string;
  device: string;
  language: string;
  userAgent: string;
  label: string;
}

@Injectable({ providedIn: 'root' })
export class DeviceInfoService {
  getSummary(): DeviceInfoSummary {
    const ua = navigator.userAgent;
    const browser = this.detectBrowser(ua);
    const os = this.detectOs(ua);
    const device = this.detectDevice(ua);
    const language = navigator.language || '—';
    const label = `${browser} · ${os}`;

    return { browser, os, device, language, userAgent: ua, label };
  }

  private detectBrowser(ua: string): string {
    if (ua.includes('Edg/')) {
      return 'Edge';
    }

    if (ua.includes('Chrome/') && !ua.includes('Edg/')) {
      return 'Chrome';
    }

    if (ua.includes('Firefox/')) {
      return 'Firefox';
    }

    if (ua.includes('Safari/') && !ua.includes('Chrome/')) {
      return 'Safari';
    }

    return 'Browser';
  }

  private detectOs(ua: string): string {
    if (ua.includes('Windows')) {
      return 'Windows';
    }

    if (ua.includes('Mac OS')) {
      return 'macOS';
    }

    if (ua.includes('Android')) {
      return 'Android';
    }

    if (ua.includes('iPhone') || ua.includes('iPad')) {
      return 'iOS';
    }

    if (ua.includes('Linux')) {
      return 'Linux';
    }

    return 'Unknown OS';
  }

  private detectDevice(ua: string): string {
    if (/Mobi|Android/i.test(ua)) {
      return 'Mobile';
    }

    if (/Tablet|iPad/i.test(ua)) {
      return 'Tablet';
    }

    return 'Desktop';
  }
}
