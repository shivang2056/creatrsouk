import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "link" ]

  switch(event) {
    this.linkTargets.forEach((element) => {
      element.classList.remove('bg-white')
      element.classList.remove('shadow')
      element.classList.add('hover:bg-gray-300')
    })

    event.currentTarget.classList.remove('hover:bg-gray-300')
    event.currentTarget.classList.add('bg-white')
    event.currentTarget.classList.add('shadow')
  }
}
