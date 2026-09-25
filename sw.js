// Dili Delivery service worker: play offline, load instantly.
// The page (HTML) is network-first so a new deploy shows up on the next visit; assets are cache-first.
// Leaderboard / stats requests go to another origin and are never cached.
const CACHE = 'dili-v2026-09-25';
const CORE = ['./', './index.html', './manifest.webmanifest', './assets/dili-hero.webp', './assets/dlicom-logo.png',
  './assets/icon-192.png', './assets/icon-512.png', './assets/icon-maskable-192.png', './assets/icon-maskable-512.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(CORE)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
    .then(() => self.clients.claim()));
});

self.addEventListener('fetch', e => {
  const req = e.request, url = new URL(req.url);
  if (req.method !== 'GET' || url.origin !== self.location.origin) return;
  const isPage = req.mode === 'navigate' || url.pathname.endsWith('/') || url.pathname.endsWith('.html');
  if (isPage) {
    // network first, fall back to the cached page when offline
    e.respondWith(fetch(req).then(res => {
      const copy = res.clone(); caches.open(CACHE).then(c => c.put('./index.html', copy)); return res;
    }).catch(() => caches.match('./index.html').then(r => r || caches.match('./'))));
    return;
  }
  // assets: cache first, refresh in the background
  e.respondWith(caches.match(req).then(hit => {
    const net = fetch(req).then(res => { if (res.ok) { const copy = res.clone(); caches.open(CACHE).then(c => c.put(req, copy)) } return res }).catch(() => hit);
    return hit || net;
  }));
});
