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


self.addEventListener('pushsubscriptionchange', function(event) {
  console.log('Push subscription change event detected:', event);

  event.waitUntil(
    (async () => {
      const vapidPublicKey = document.querySelector('meta[name="vapid-public-key"]')
      const convertedVapidKey = urlBase64ToUint8Array(vapidPublicKey);

      try {
        // Resubscribe the user
        const newSubscription = await self.registration.pushManager.subscribe({
          userVisibleOnly: true,
          applicationServerKey: convertedVapidKey
        });

        // Send the new subscription details to the server
        await fetch('/push_subscriptions', {
          method: 'post',
          headers: {
            'Content-type': 'application/json',
            'X-CSRF-Token': await getCsrfToken()
          },
          body: JSON.stringify({
            push_subscription: newSubscription
          }),
        });
        console.log('Resubscribed successfully:', newSubscription);
      } catch (error) {
        console.error('Error during resubscription:', error);
      }
    })()
  );
});

function urlBase64ToUint8Array(base64String) {
  const padding = '='.repeat((4 - base64String.length % 4) % 4);
  const base64 = (base64String + padding)
    .replace(/-/g, '+')
    .replace(/_/g, '/');

  const rawData = atob(base64);
  const outputArray = new Uint8Array(rawData.length);

  for (let i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

// Function to get CSRF token (if needed)
function getCsrfToken() {
  return document.querySelector('meta[name="csrf-token"]').getAttribute('content');
}


