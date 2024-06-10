// public/service_worker.js

self.addEventListener('install', (event) => {
  console.log('Service Worker installing.');
  // Add a call to skipWaiting here if you want to immediately activate the service worker
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  console.log('Service Worker activating.');
});

self.addEventListener('fetch', (event) => {
  event.respondWith(fetch(event.request));
});
