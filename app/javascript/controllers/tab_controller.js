import { Controller } from "@hotwired/stimulus"

const DEFAULT_CLASS = 'hover:bg-gray-300';
const ACTIVE_CLASS = ['bg-white', 'shadow'];

export default class extends Controller {
  static targets = ["link"]

  switch(event) {
    this.linkTargets.forEach(element => {
      this.updateClasses(element, [DEFAULT_CLASS], ACTIVE_CLASS);
    });

    this.updateClasses(event.currentTarget, ACTIVE_CLASS, [DEFAULT_CLASS]);
  }

  updateClasses(element, addClasses, removeClasses) {
    element.classList.remove(...removeClasses);
    element.classList.add(...addClasses);
  }
}
