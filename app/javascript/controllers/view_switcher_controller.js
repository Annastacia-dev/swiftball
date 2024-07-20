import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"];

  connect() {
    this.selectTarget.addEventListener("change", this.submitForm.bind(this));
  }

  submitForm(event) {
    event.target.form.submit();
  }
}

