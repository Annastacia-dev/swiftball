// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "chartkick"
import "Chart.bundle"

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/service_worker.js')
    .then((_registration) => {
    })
    .catch((error) => {
      console.error('Service Worker registration failed:', error);
    });
}
