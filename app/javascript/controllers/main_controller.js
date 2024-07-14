// app/javascript/controllers/main_controller.js

import { Controller } from "@hotwired/stimulus";
import confetti from 'canvas-confetti';

export default class extends Controller {
  static targets = ["flash", "progressBar", "confettiButton"]

  connect() {
    this.startFlashTimer()
    this.setupConfettiButton()
  }

  startFlashTimer() {
    if (this.hasFlashTarget) {
      this.progress = 100
      this.intervalId = setInterval(() => {
        this.progress -= 1
        this.progressBarTarget.style.width = `${this.progress}%`

        if (this.progress <= 0) {
          clearInterval(this.intervalId)
          this.flashTarget.classList.add('hidden')
        }
      }, 50)
    }
  }

  closeFlash() {
    if (this.hasFlashTarget) {
      this.flashTarget.classList.add('hidden')
    }
  }

  setupConfettiButton() {
    if (this.hasConfettiButtonTarget) {
      this.confettiButtonTarget.addEventListener('click', this.triggerConfetti)
    }
  }

  triggerConfetti() {
    var duration = 15 * 1000
    var animationEnd = Date.now() + duration
    var defaults = { startVelocity: 30, spread: 360, ticks: 60, zIndex: 0 }

    function randomInRange(min, max) {
      return Math.random() * (max - min) + min
    }

    var interval = setInterval(function() {
      var timeLeft = animationEnd - Date.now()

      if (timeLeft <= 0) {
        return clearInterval(interval)
      }

      var particleCount = 50 * (timeLeft / duration)
      confetti({ ...defaults, particleCount, origin: { x: randomInRange(0.1, 0.3), y: Math.random() - 0.2 } })
      confetti({ ...defaults, particleCount, origin: { x: randomInRange(0.7, 0.9), y: Math.random() - 0.2 } })
    }, 250)
  }
}
