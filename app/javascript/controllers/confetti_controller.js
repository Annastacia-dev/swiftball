// app/javascript/controllers/confetti_controller.js

import { Controller } from "@hotwired/stimulus";
import confetti from 'canvas-confetti';

export default class extends Controller {
  static targets = ["confettiButton"]

  connect() {
    this.checkConditionsAndTriggerConfetti()
  }

  checkConditionsAndTriggerConfetti() {
    const attemptPosition = parseInt(this.element.dataset.attemptPosition, 10)
    const quizStatus = this.element.dataset.quizStatus

    if (quizStatus === 'closed') {
      if (attemptPosition === 1) {
        this.fireworkConfetti()
        this.rapidConfetti()
        this.starsConfetti()
        this.emojiConfetti()
      } else if (attemptPosition === 2 ){
        this.fireworkConfetti()
        this.emojiConfetti()
      } else if (attemptPosition === 3 ){
        this.basicConfetti()
        this.emojiConfetti()
      }
    }
  }

  rapidConfetti() {
    var end = Date.now() + (15 * 1000);

    var colors = ['#ec4899', '#ffffff'];

    (function frame() {
      confetti({
        particleCount: 2,
        angle: 60,
        spread: 55,
        origin: { x: 0 },
        colors: colors
      });
      confetti({
        particleCount: 2,
        angle: 120,
        spread: 55,
        origin: { x: 1 },
        colors: colors
      });

      if (Date.now() < end) {
        requestAnimationFrame(frame);
      }
    }());
  }

  fireworkConfetti() {
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

  starsConfetti () {
    var defaults = {
      spread: 360,
      ticks: 50,
      gravity: 0,
      decay: 0.94,
      startVelocity: 30,
      colors: ['FFE400', 'FFBD00', 'E89400', 'FFCA6C', 'FDFFB8']
    };

    function shoot() {
      confetti({
        ...defaults,
        particleCount: 40,
        scalar: 1.2,
        shapes: ['star']
      });

      confetti({
        ...defaults,
        particleCount: 10,
        scalar: 0.75,
        shapes: ['circle']
      });
    }

    setTimeout(shoot, 0);
    setTimeout(shoot, 100);
    setTimeout(shoot, 200);
  }

  basicConfetti () {
    confetti({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.6 }
    });
  }

  emojiConfetti () {
    var scalar = 2;
    var greenHeart = confetti.shapeFromText({ text: '💚', scalar });
    var yellowHeart = confetti.shapeFromText({ text: '💛', scalar });
    var purpleHeart = confetti.shapeFromText({ text: '💜', scalar });
    var blackHeart = confetti.shapeFromText({ text: '🖤', scalar });
    var brownHeart = confetti.shapeFromText({ text: '🤎', scalar });
    var blueHeart = confetti.shapeFromText({ text: '💙', scalar });


    var defaults = {
      spread: 360,
      ticks: 60,
      gravity: 0,
      decay: 0.96,
      startVelocity: 20,
      shapes: [greenHeart, yellowHeart, purpleHeart, blackHeart, brownHeart, blueHeart],
      scalar
    };

    function shoot() {
      confetti({
        ...defaults,
        particleCount: 30
      });

      confetti({
        ...defaults,
        particleCount: 5,
        flat: true
      });

      confetti({
        ...defaults,
        particleCount: 15,
        scalar: scalar / 2,
        shapes: ['circle']
      });
    }

    setTimeout(shoot, 0);
    setTimeout(shoot, 100);
    setTimeout(shoot, 200);
  }

}
