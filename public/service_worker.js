// public/service_worker.js

self.addEventListener('install', (event) => {
  // Add a call to skipWaiting here if you want to immediately activate the service worker
  self.skipWaiting();

  // Put `offline.html` page into cache
  var offlineRequest = new Request('offline.html');
  event.waitUntil(
    fetch(offlineRequest).then(function(response) {
      return caches.open('offline').then(function(cache) {
        console.log('[oninstall] Cached offline page', response.url);
        return cache.put(offlineRequest, response);
      });
    })
  );
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

self.addEventListener('fetch', function(event) {
  // Only fall back for HTML documents.
  var request = event.request;
  // && request.headers.get('accept').includes('text/html')
  if (request.method === 'GET') {
    // `fetch()` will use the cache when possible, to this examples
    // depends on cache-busting URL parameter to avoid the cache.
    event.respondWith(
      fetch(request).catch(function(error) {
        // `fetch()` throws an exception when the server is unreachable but not
        // for valid HTTP responses, even `4xx` or `5xx` range.
        console.error(
          '[onfetch] Failed. Serving cached offline fallback ' +
          error
        );
        return caches.open('offline').then(function(cache) {
          return cache.match('offline.html');
        });
      })
    );
  }
  // Any other handlers come here. Without calls to `event.respondWith()` the
  // request will be handled without the ServiceWorker.
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


