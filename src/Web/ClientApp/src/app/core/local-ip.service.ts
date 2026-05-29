import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class LocalIpService {
  /** Best-effort local IPv4 via WebRTC (may be blocked by browser privacy settings). */
  discoverLocalIpv4(timeoutMs = 3500): Promise<string | null> {
    if (typeof RTCPeerConnection === 'undefined') {
      return Promise.resolve(null);
    }

    return new Promise((resolve) => {
      const candidates = new Set<string>();
      const pc = new RTCPeerConnection({
        iceServers: [{ urls: 'stun:stun.l.google.com:19302' }],
      });

      const finish = (value: string | null) => {
        pc.onicecandidate = null;
        pc.close();
        resolve(value);
      };

      const timer = setTimeout(() => {
        finish(this.pickPrivateIp(candidates));
      }, timeoutMs);

      pc.onicecandidate = (event) => {
        if (!event.candidate?.candidate) {
          return;
        }

        const match = /([0-9]{1,3}(?:\.[0-9]{1,3}){3})/.exec(event.candidate.candidate);
        if (match && this.isPrivateIpv4(match[1])) {
          candidates.add(match[1]);
        }
      };

      pc.createDataChannel('ipnote');
      pc.createOffer()
        .then((offer) => pc.setLocalDescription(offer))
        .catch(() => {
          clearTimeout(timer);
          finish(null);
        });

      pc.onicegatheringstatechange = () => {
        if (pc.iceGatheringState === 'complete') {
          clearTimeout(timer);
          finish(this.pickPrivateIp(candidates));
        }
      };
    });
  }

  private pickPrivateIp(candidates: Set<string>): string | null {
    if (candidates.size === 0) {
      return null;
    }

    return [...candidates][0] ?? null;
  }

  private isPrivateIpv4(ip: string): boolean {
    const parts = ip.split('.').map((p) => Number.parseInt(p, 10));
    if (parts.length !== 4 || parts.some((n) => Number.isNaN(n))) {
      return false;
    }

    if (parts[0] === 10) {
      return true;
    }

    if (parts[0] === 172 && parts[1] >= 16 && parts[1] <= 31) {
      return true;
    }

    if (parts[0] === 192 && parts[1] === 168) {
      return true;
    }

    return parts[0] === 169 && parts[1] === 254;
  }
}
