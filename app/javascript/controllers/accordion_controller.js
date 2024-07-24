import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"];

  toggle() {
    this.contentTarget.classList.toggle("collapse");
    this.iconTarget.classList.toggle("fa-chevron-down");
    this.iconTarget.classList.toggle("fa-chevron-up");
  }
}

