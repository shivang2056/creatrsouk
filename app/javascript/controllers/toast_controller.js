import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    this.element.style.display = 'block'
    this.startTimer()
  }

  startTimer() {
    setTimeout(() => {
      this.close()
    }, 5000)
  }

  close() {
    this.element.style.animation = 'slideUp 0.5s ease-out';
    this.element.addEventListener('animationend', () => {
      this.element.style.display = 'none';
    }, { once: true });
  }
}
