import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="drawer"
export default class extends Controller {
  static targets = ["drawer", "content"];

  connect() {
    const urlParams = new URLSearchParams(window.location.search);
    // Loop through each drawer element
    this.drawerTargets.forEach((drawer) => {
      const drawerId = drawer.dataset.id;
      const drawerOpenParam = urlParams.get(drawerId);

      if (drawerOpenParam && drawerOpenParam.toLowerCase() === 'true') {
        this.open(drawer);
      } else {
        this.close(drawer);
      }
    });
  }

  toggle(event) {
    if (event) {
      event.preventDefault();
    }
    if (this.drawerTarget.classList.contains("hidden")) {
      this.open();
    } else {
      this.close();
    }
  }

  open() {
    this.drawerTarget.classList.remove("hidden");
    this.loadContent();
  }

  close(event) {
    this.drawerTarget.classList.add("hidden");
  }

  async loadContent() {
    if (this.contentTarget.innerHTML.trim() === "") {
      const url = this.contentTarget.dataset.url;
      console.log("Fetching content from:", url); // Log the URL
      const response = await fetch(url);
      if (response.ok) {
        const html = await response.text();
        console.log("Loaded HTML:", html); // Log the fetched HTML
        this.contentTarget.innerHTML = html;
      } else {
        console.error("Failed to load content:", response.status);
      }
    }
  }
}
