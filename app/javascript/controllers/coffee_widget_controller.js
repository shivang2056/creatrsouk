import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="coffee-widget"
export default class extends Controller {
  static targets = ["quantityOption", "quantityInput", "coffeeAmount", "totalAmount", "coffeeAmountInButton"]
  static values = { productPrice: Number, coffeePrice: Number }

  connect() {
  }

  setAmount({ params }) {
    const quantity = this.resolveQuantity(params);
    const coffeeAmount = this.calculateCoffeeAmount(quantity);
    const total = this.calculateTotalAmount(coffeeAmount);

    this.updateQuantityOptionsDisplay(quantity);
    this.updateDisplayedAmounts(coffeeAmount, total);
  }

  resolveQuantity(params) {
    return params.quantity || parseInt(this.quantityInputTarget.value || 1);
  }

  calculateCoffeeAmount(quantity) {
    return quantity * this.coffeePriceValue;
  }

  calculateTotalAmount(coffeeAmount) {
    return this.productPriceValue + coffeeAmount;
  }

  updateQuantityOptionsDisplay(selectedQuantity) {
    this.quantityOptionTargets.forEach((element) => {
      const quantity = parseInt(element.dataset.coffeeWidgetQuantityParam);
      if (selectedQuantity === quantity) {
        element.classList.replace('border-gray-300', 'border-gray-500');
        element.classList.add('bg-gray-300');
      } else {
        element.classList.replace('border-gray-500', 'border-gray-300');
        element.classList.remove('bg-gray-300');
      }
    });
  }

  updateDisplayedAmounts(coffeeAmount, total) {
    this.quantityInputTarget.value = coffeeAmount / this.coffeePriceValue;

    if (this.hasCoffeeAmountTarget) {
      this.coffeeAmountTarget.innerHTML = `$${coffeeAmount.toFixed(2)}`;
    }

    if (this.hasTotalAmountTarget) {
      this.totalAmountTarget.innerHTML = `$${total.toFixed(2)}`;
    }

    if (this.hasCoffeeAmountInButtonTarget) {
      this.coffeeAmountInButtonTarget.innerHTML = `$${coffeeAmount.toFixed(2)}`;
    }
  }
}
