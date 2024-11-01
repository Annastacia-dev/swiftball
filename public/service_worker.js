// public/service_worker.js

self.addEventListener('install', (event) => {
  // Add a call to skipWaiting here if you want to immediately activate the service worker
  self.skipWaiting();

  event.waitUntil(async function() {
    const cache = await caches.open('offline.html');
    await cache.addAll(['offline.html', 'icon-144.png']);
  }());

});

self.addEventListener('activate', (_event) => {
});

self.addEventListener('push', function(event) {

  // Retrieve the textual payload from event.data (a PushMessageData object).
  const payload = event.data ? event.data.json() : { body: 'no payload', url: '' };

  // Define the notification options.
  const options = {
    body: payload.body,
    icon: payload.icon,
    badge: payload.badge,
    vibrate: [200, 100, 200],
    data: { url: payload.url },
    requireInteraction: true
  };

  // Keep the service worker alive until the notification is created.
  event.waitUntil(
    self.registration.showNotification(payload.title, options)
  );
});

self.addEventListener('notificationclick', function(event) {
  event.notification.close(); // Close the notification

  // Open the URL specified in the data property
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function(clientList) {
      for (let i = 0; i < clientList.length; i++) {
        const client = clientList[i];
        if (client.url === event.notification.data.url && 'focus' in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow(event.notification.data.url);
      }
    })
  );
});

self.addEventListener('fetch', (event) => {
  const { request } = event;

  // Always bypass for range requests, due to browser bugs
  if (request.headers.has('range')) return;
  event.respondWith(async function() {
    // Try to get from the cache:
    const cachedResponse = await caches.match(request);
    if (cachedResponse) return cachedResponse;

    try {
      // Otherwise, get from the network
      return await fetch(request);
    } catch (err) {
      // If this was a navigation, show the offline page:
      if (request.mode === 'navigate') {
        return caches.match('offline.html');
      }

      // Otherwise throw
      throw err;
    }
  }());
});


