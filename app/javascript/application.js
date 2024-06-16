// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "chartkick"
import "Chart.bundle"

// Register a Service Worker.
navigator.serviceWorker.register('service_worker.js');

if ('Notification' in window && navigator.serviceWorker) {
  Notification.requestPermission(status => {
    //console.log('Notification permission status:', status);
  });
}


navigator.serviceWorker.ready
.then(function(registration) {
  // Use the PushManager to get the user's subscription to the push service.
  return registration.pushManager.getSubscription()
  .then(async function(subscription) {
    // If a subscription was found, return it.
    if (subscription) {
      return subscription;
    }

    // Get the server's public key
    const vapidPublicKey = document.querySelector('meta[name="vapid-public-key"]').getAttribute('content');
    // Chrome doesn't accept the base64-encoded (string) vapidPublicKey yet
    // urlBase64ToUint8Array() is defined in /tools.js
    const convertedVapidKey = urlBase64ToUint8Array(vapidPublicKey);

    // Otherwise, subscribe the user (userVisibleOnly allows to specify that we don't plan to
    // send notifications that don't have a visible effect for the user).
    return registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: convertedVapidKey
    });
  });
}).then(function(subscription) {
  // Send the subscription details to the server using the Fetch API.
  fetch('./push_subscriptions', {
    method: 'post',
    headers: {
      'Content-type': 'application/json',
      'X-CSRF-Token': getCsrfToken()
    },
    body: JSON.stringify({
      push_subscription: subscription
    }),
  });
});

function urlBase64ToUint8Array(base64String) {
  var padding = '='.repeat((4 - base64String.length % 4) % 4);
  var base64 = (base64String + padding)
      .replace(/\-/g, '+')
      .replace(/_/g, '/');

  var rawData = window.atob(base64);
  var outputArray = new Uint8Array(rawData.length);

  for (var i = 0; i < rawData.length; ++i) {
      outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

function getCsrfToken() {
  return document.querySelector('meta[name="csrf-token"]').getAttribute('content');
}



