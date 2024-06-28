import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="coffee-widget"
export default class extends Controller {
  static targets = ["quantityOption", "quantityInput", "coffeeAmount", "totalAmount", "coffeeAmountInButton"]
  static values = { productPrice: Number, coffeePrice: Number }

  connect() {
  }

  setAmount({params}) {
    let quantity = params.quantity || parseInt(this.quantityInputTarget.value || 1)
    let coffeeAmount = quantity * this.coffeePriceValue
    let total = this.productPriceValue + coffeeAmount

    this.quantityOptionTargets.forEach((element) => {
      if (quantity === parseInt(element.dataset.coffeeWidgetQuantityParam)) {
        element.classList.remove('border-gray-300')
        element.classList.add('border-gray-500')
        element.classList.add('bg-gray-300')
      } else {
        element.classList.remove('border-gray-500')
        element.classList.remove('bg-gray-300')
        element.classList.add('border-gray-300')
      }
    })

    this.quantityInputTarget.value = quantity

    if (this.hasCoffeeAmountTarget) {
      this.coffeeAmountTarget.innerHTML = `$${coffeeAmount.toFixed(2)}`
    }

    if (this.hasTotalAmountTarget) {
      this.totalAmountTarget.innerHTML = `$${total.toFixed(2)}`
    }

    if (this.hasCoffeeAmountInButtonTarget) {
      this.coffeeAmountInButtonTarget.innerHTML = `$${coffeeAmount.toFixed(2)}`
    }
  }
}
