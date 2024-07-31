module CheckoutComplete
  class FinancialManager
    def initialize(product, session, quantity, net_amount)
      @product = product
      @session = session
      @quantity = quantity
      @net_amount = net_amount
    end

    def process
      update_product_financials
      update_customer_purchases
    end

    private

    def update_product_financials
      financial = @product.financial || @product.build_financial(user: @product.user, sales: 0, revenue: 0)
      financial.revenue += (@net_amount / 100.00)
      financial.sales += 1
      financial.save!
    end

    def update_customer_purchases
      customer = User.find_or_initialize_by(email: @session.customer_details.email)
      customer.update!(customer: true, password: SecureRandom.uuid) unless customer.persisted?

      customer.user_purchases.create(
        product: @product,
        price: @product.price,
        checkout_session_id: @session.id,
        receipt_url: @session.payment_intent.latest_charge.receipt_url,
        quantity: @quantity
      )
    end
  end
end
