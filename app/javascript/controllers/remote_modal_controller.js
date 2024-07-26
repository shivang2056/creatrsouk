import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remote-modal"
export default class extends Controller {
  connect() {
    this.addBlurToGrandParent();
    this.showModal();
    this.setupEventListeners();
  }

  disconnect() {
    this.removeEventListeners();
  }

  addBlurToGrandParent() {
    this.grandParentElement.classList.add('blur-sm');
  }

  removeBlurFromGrandParent() {
    this.grandParentElement.classList.remove('blur-sm');
  }

  showModal() {
    this.element.showModal();
  }

  setupEventListeners() {
    this.element.addEventListener("close", this.handleClose);
  }

  removeEventListeners() {
    this.element.removeEventListener("close", this.handleClose);
  }

  handleClose = (e) => {
    this.removeBlurFromGrandParent();
  }

  get grandParentElement() {
    return this.element.parentElement.parentElement;
  }
}
