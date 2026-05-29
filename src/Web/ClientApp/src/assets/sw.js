const CACHE = 'ipnote-shell-v1';
const SHELL = ['/', '/offline.html', '/manifest.webmanifest', '/favicon.png', '/apple-touch-icon.png', '/assets/icons/icon-192.png', '/assets/icons/icon-512.png'];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE).then((cache) => cache.addAll(SHELL)).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(self.clients.claim());
});

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') {
    return;
  }

  event.respondWith(
    fetch(event.request)
      .then((response) => response)
      .catch(() =>
        caches.match(event.request).then((cached) => cached ?? caches.match('/offline.html'))
      )
  );
});
