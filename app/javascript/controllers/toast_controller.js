import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
export default class extends Controller {
  static animationDuration = '0.5s'; // Duration for the slide-up animation
  static displayDuration = 5000; // Duration to display the toast

  connect() {
    this.showToast();
  }

  showToast() {
    this.element.style.display = 'block';
    this.scheduleClose();
  }

  scheduleClose() {
    setTimeout(() => {
      this.initiateCloseAnimation();
    }, this.constructor.displayDuration);
  }

  initiateCloseAnimation() {
    this.element.style.animation = `slideUp ${this.constructor.animationDuration} ease-out`;
    this.element.addEventListener('animationend', this.hideToast, { once: true });
  }

  hideToast = () => {
    this.element.style.display = 'none';
  }
}
