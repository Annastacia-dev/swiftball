import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="allow-notifications"
export default class extends Controller {
  static targets = [ "button", "message", "divider" ]

  connect() {
    // Check for existence of buttonTarget and dividerTarget before accessing them
    if (this.hasButtonTarget) {
      this.buttonTarget.style.display = 'none';
    }

    if (this.hasDividerTarget) {
      this.dividerTarget.style.display = 'none';
    }

    // Check if the browser supports notifications
    if (!("Notification" in window)) {
      if (this.hasMessageTarget) {
        this.messageTarget.classList.remove('hidden');
        this.messageTarget.textContent = "Notifications are not supported by your browser.";
      }
      return;
    }

    // Check if permission is already granted
    if (Notification.permission === "granted") {
      this.hideButton();
    } else {
      this.showButton();
    }
  }

  requestPermission() {
    Notification.requestPermission().then((permission) => {
      if (permission === "granted") {
        this.hideButton();
      } else {
        const instructionsElement = document.getElementById('allow-notifications-instructions');
        if (instructionsElement) {
          instructionsElement.classList.remove('hidden');
        }
      }
    });
  }

  showButton() {
    // Check for existence of buttonTarget and dividerTarget before accessing them
    if (this.hasButtonTarget) {
      this.buttonTarget.style.display = 'block';
    }
    if (this.hasDividerTarget) {
      this.dividerTarget.style.display = 'block';
    }
  }

  hideButton() {
    // Check for existence of buttonTarget and dividerTarget before accessing them
    if (this.hasButtonTarget) {
      this.buttonTarget.style.display = 'none';
    }
    if (this.hasDividerTarget) {
      this.dividerTarget.style.display = 'none';
    }
  }
}
