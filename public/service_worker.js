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

self.addEventListener('push', function(event) {
  //console.log('Push event received:', event);

  // Retrieve the textual payload from event.data (a PushMessageData object).
  const payload = event.data ? event.data.json() : { body: 'no payload', url: '' };
   //console.log('Push event payload:', payload);

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
  //console.log('Notification click received:', event);
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

