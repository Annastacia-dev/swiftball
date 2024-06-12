// public/service_worker.js

self.addEventListener('install', (_event) => {
  // Add a call to skipWaiting here if you want to immediately activate the service worker
  self.skipWaiting();
});

self.addEventListener('activate', (_event) => {
});

self.addEventListener('fetch', (event) => {
  event.respondWith(fetch(event.request));
});
