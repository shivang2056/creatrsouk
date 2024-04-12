import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "link" ]

  switch(event) {
    this.linkTargets.forEach((element) => {
      element.classList.remove('text-blue-600')
      element.classList.add('text-gray-500')
    })

    event.currentTarget.classList.remove('text-gray-500')
    event.currentTarget.classList.add('text-blue-600')
  }
}
