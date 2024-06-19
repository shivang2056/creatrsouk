import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="coffee-widget"
export default class extends Controller {
  static targets = ["amountOption", "amountInput", "coffeeAmount", "totalAmount", "coffeeAmountInButton"]
  static values = { productPrice: Number }

  connect() {
  }

  setAmount({params}) {
    let amount = params.option || parseInt(this.amountInputTarget.value || 1)
    let total = this.productPriceValue + amount

    this.amountOptionTargets.forEach((element) => {
      if (amount === parseInt(element.dataset.coffeeWidgetOptionParam)) {
        element.classList.remove('border-gray-300')
        element.classList.add('border-gray-500')
        element.classList.add('bg-gray-300')
      } else {
        element.classList.remove('border-gray-500')
        element.classList.remove('bg-gray-300')
        element.classList.add('border-gray-300')
      }
    })

    this.amountInputTarget.value = amount

    if (this.hasCoffeeAmountTarget) {
      this.coffeeAmountTarget.innerHTML = `$${amount.toFixed(2)}`
    }

    if (this.hasTotalAmountTarget) {
      this.totalAmountTarget.innerHTML = `$${total.toFixed(2)}`
    }

    if (this.hasCoffeeAmountInButtonTarget) {
      this.coffeeAmountInButtonTarget.innerHTML = `$${amount}`
    }
  }
}
