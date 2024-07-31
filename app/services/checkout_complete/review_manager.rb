module CheckoutComplete
  class ReviewManager
    def initialize(coffee_data, purchase, is_a_coffee_product)
      @coffee_data = coffee_data
      @purchase = purchase
      @is_a_coffee_product = is_a_coffee_product
    end

    def create_coffee_review
      return if not_applicable?

      @purchase.create_review!(comment: @coffee_data.comment)
      @purchase.user.update_name!(@coffee_data.giver_name)
    end

    private

    def not_applicable?
      !(@is_a_coffee_product && @coffee_data[:coffee] == "true" && @coffee_data[:comment].present?)
    end
  end
end
