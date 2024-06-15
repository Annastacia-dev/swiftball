// public/service_worker.js

self.addEventListener('install', (_event) => {
  // Add a call to skipWaiting here if you want to immediately activate the service worker
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  console.log('Service worker activated.');
  event.waitUntil(self.clients.claim());
});

self.addEventListener('fetch', (event) => {
  event.respondWith(fetch(event.request));
});

// Register event listener for the 'push' event.
self.addEventListener('push', function(event) {
  console.log(event)
  // Retrieve the textual payload from event.data (a PushMessageData object).
  // Other formats are supported (ArrayBuffer, Blob, JSON), check out the documentation
  // on https://developer.mozilla.org/en-US/docs/Web/API/PushMessageData.
  const payload = event.data ? event.data.text() : 'no payload';

  console.log(payload)

   // Define the notification options.
   const options = {
    body: payload,
    icon: '/icon-48.png', // Add an icon if you have one
    badge: '/icon-48.png', // Add a badge if you have one
    vibrate: [200, 100, 200], // Vibration pattern
    data: { url: 'https://swiftball.online' }, // Additional data if needed
  };

  // Keep the service worker alive until the notification is created.
  event.waitUntil(
    self.registration.showNotification('ServiceWorker Cookbook', options)
  );
});

self.addEventListener('notificationclick', function(event) {
  console.log('Notification click received:', event);
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
