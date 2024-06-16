import { Controller } from "@hotwired/stimulus"

const starColors = {
  'white': 'fill-white',
  'gray': 'fill-gray-700'
}

// Connects to data-controller="rating"
export default class extends Controller {
  static targets = ['input', 'star'];

  connect() {
  }

  setRating(e) {
    const rating = parseInt(e.target.dataset.rating);

    this.starTargets.forEach((star) => {
      if (parseInt(star.dataset.rating) <= rating) {
        star.classList.remove(starColors['white']);
        star.classList.add(starColors['gray']);
      } else {
        star.classList.remove(starColors['gray']);
        star.classList.add(starColors['white']);
      }
    });

    this.inputTarget.value = rating;
  }
}
