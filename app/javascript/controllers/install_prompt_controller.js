import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="install-prompt"
export default class extends Controller {
  static targets = [ "button", "divider" ]

  connect() {
    this.deferredPrompt = null
    this.buttonTarget.style.display = 'none'
    this.dividerTarget.style.display = 'none'

    window.addEventListener('beforeinstallprompt', (e) => {
      // Prevent the mini-infobar from appearing on mobile
      e.preventDefault()
      // Save the event so it can be triggered later.
      this.deferredPrompt = e
      // Update UI notify the user they can install the PWA
      this.buttonTarget.style.display = 'block'
      this.dividerTarget.style.display = 'block'
    })
  }

  install() {
    if (this.deferredPrompt) {
      // Hide the install button
      this.buttonTarget.style.display = 'none'
      this.dividerTarget.style.display = 'none'
      // Show the install prompt
      this.deferredPrompt.prompt()
      // Wait for the user to respond to the prompt
      this.deferredPrompt.userChoice.then((choiceResult) => {
        if (choiceResult.outcome === 'accepted') {
        } else {
        }
        this.deferredPrompt = null
      })
    }
  }

}
