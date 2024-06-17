// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "chartkick"
import "Chart.bundle"

if ('Notification' in window && navigator.serviceWorker) {
  Notification.requestPermission(_status => {
    //console.log('Notification permission status:', status);
  });
}


if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/service_worker.js')
  .then(function(registration) {
    // Use the PushManager to get the user's subscription to the push service.
    return registration.pushManager.getSubscription()
    .then(async function(subscription) {
      // check if subscription exists
      if (subscription) {
        console.log('User is already subscribed:', subscription);
        return subscribeUser(registration);
      } else {
        console.log('No existing subscription found, prompting user to subscribe...');
        // Subscribe the user
        return subscribeUser(registration);
      }
    });
  })
}

// Function to handle resubscription
function subscribeUser(registration) {
  // Get the server's public key
  const vapidPublicKey = document.querySelector('meta[name="vapid-public-key"]').getAttribute('content');
  // Chrome doesn't accept the base64-encoded (string) vapidPublicKey yet
  // urlBase64ToUint8Array() is defined in /tools.js
  const convertedVapidKey = urlBase64ToUint8Array(vapidPublicKey);

  // Subscribe the user again (userVisibleOnly allows to specify that we don't plan to
  // send notifications that don't have a visible effect for the user).
  registration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: convertedVapidKey
  })
  .then(function(subscription) {
    // Send the new subscription details to the server using the Fetch API.
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
  })
  .catch(function(error) {
    console.error('Error during resubscription:', error);
    // Handle the error (e.g., show an alert to the user)
    // alert('Unable to resubscribe to notifications. Please try again later.');
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



