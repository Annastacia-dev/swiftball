import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="allow-notifications"
export default class extends Controller {
  static targets = [ "button", "message", "divider" ]

  connect() {

    this.buttonTarget.style.display = 'none'
    this.dividerTarget.style.display = 'none'

    // Check if the browser supports notifications
    if (!("Notification" in window)) {
      document.getElementById('notification-message').classList.remove('hidden')
      this.messageTarget.textContent = "Notifications are not supported by your browser.";
      return;
    }

    // Check if permission is already granted
    if (Notification.permission === "granted") {
      this.hideButton();
    } else {
      this.showButton()
    }
  }

  requestPermission() {
    Notification.requestPermission().then((permission) => {
      if (permission === "granted") {
        this.hideButton();
      } else {
        document.getElementById('allow-notifications-instructions').classList.remove('hidden')
        return;
      }
    });
  }

  showButton(){
    this.buttonTarget.style.display = 'block'
    this.dividerTarget.style.display = 'block'
  }

  hideButton() {
    this.buttonTarget.style.display = 'none'
    this.dividerTarget.style.display = 'none'
  }
}
