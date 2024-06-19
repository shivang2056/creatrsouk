import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remote-modal"
export default class extends Controller {
  connect() {
    this.element.parentElement.parentElement.classList.add('blur-sm');
    this.element.showModal();

    this.element.addEventListener("close", (e) => {
      this.element.parentElement.parentElement.classList.remove('blur-sm');
    });
  }
}
