import { Controller } from "@hotwired/stimulus"

const starColors = {
  white: 'fill-white',
  gray: 'fill-gray-700'
}

// Connects to data-controller="rating"
export default class extends Controller {
  static targets = ['input', 'star'];

  connect() {
  }

  setRating(event) {
    const rating = parseInt(event.target.dataset.rating);
    this.updateStars(rating);
    this.inputTarget.value = rating;
  }

  updateStars(rating) {
    this.starTargets.forEach(star => {
      const starRating = parseInt(star.dataset.rating);
      this.updateStarColor(star, starRating <= rating);
    });
  }

  updateStarColor(star, isActive) {
    star.classList.remove(starColors.white, starColors.gray);
    star.classList.add(isActive ? starColors.gray : starColors.white);
  }
}
