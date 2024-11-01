import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"];

  toggle(event) {
    this.closeAllSections();

    const content = event.currentTarget.nextElementSibling;
    const icon = event.currentTarget.querySelector('[data-your-controller-name-target="icon"]');

    content.classList.toggle("collapse");
    icon.classList.toggle("fa-chevron-down");
    icon.classList.toggle("fa-chevron-up");
  }

  closeAllSections() {
    this.contentTargets.forEach((content) => {
      if (!content.classList.contains("collapse")) {
        content.classList.add("collapse");
      }
    });

    this.iconTargets.forEach((icon) => {
      if (icon.classList.contains("fa-chevron-up")) {
        icon.classList.remove("fa-chevron-up");
        icon.classList.add("fa-chevron-down");
      }
    });
  }
}
