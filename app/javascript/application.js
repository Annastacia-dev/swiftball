// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "chartkick";
import "Chart.bundle";

// Register a Service Worker.
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/service_worker.js')
    .then(async function (registration) {

      const subscription = await registration.pushManager.getSubscription();
      if (subscription) {
        return subscription;
      }
      const vapidPublicKey = document.querySelector('meta[name="vapid-public-key"]').getAttribute('content');
      const convertedVapidKey = urlBase64ToUint8Array(vapidPublicKey);
      return await registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: convertedVapidKey
      });
    }).then(function (subscription) {
      return fetch('/push_subscriptions', {
        method: 'post',
        headers: {
          'Content-type': 'application/json',
          'X-CSRF-Token': getCsrfToken()
        },
        body: JSON.stringify({
          push_subscription: subscription
        })
      });
    }).then(function (response) {
      if (!response.ok) {
        throw new Error('Network response was not ok.');
      }
      return response.json();
    }).then(function (_data) {
    }).catch(function (error) {
      console.error('ServiceWorker registration failed: ', error);
    });
}

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
