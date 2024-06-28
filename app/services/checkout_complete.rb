class CheckoutComplete

  def initialize(stripe_event)
    @session = retrieve_stripe_checkout_session(stripe_event)
    @balance_transaction = @session.payment_intent.latest_charge.balance_transaction
  end

  def self.process(stripe_event)
    self.new(stripe_event).process
  end

  def process
    return if @session.payment_status != 'paid'

    if @session.line_items.data.count == 2
      net_amounts = compute_net_amount_for_each_line_item

      2.times { |index| process_session_line_item(index, net_amounts[index]) }
    else
      process_session_line_item(0, @balance_transaction.net)
    end
  end

  private

  def retrieve_stripe_checkout_session(stripe_event)
    Stripe::Checkout::Session.retrieve({
      id: stripe_event.data.object.id,
      expand: ['line_items.data.price.product', 'payment_intent.latest_charge.balance_transaction']
    }, header(stripe_event))
  end

  def process_session_line_item(index, net_amount)
    product = Product.find_by(stripe_id: @session.line_items.data[index].price.product.id)

    purchase = update_customer_purchases(product, index)
    update_product_financials(product, net_amount)
    create_coffee_review(@session.metadata, purchase, product.is_a?(CoffeeProduct))
  end

  def update_customer_purchases(product, index)
    customer.update!(customer: true, password: SecureRandom.uuid) unless customer.persisted?

    customer.user_purchases.create(product: product,
      price: product.price,
      checkout_session_id: @session.id,
      receipt_url: @session.payment_intent.latest_charge.receipt_url,
      quantity: @session.line_items.data[index].quantity
    )
  end

  def update_product_financials(product, net_amount)
    financial = product.financial || product.build_financial(user: product.user, sales: 0, revenue: 0)
    financial.revenue += ( net_amount / 100.00)
    financial.sales += 1
    financial.save!
  end

  def create_coffee_review(coffee_params, purchase, is_a_coffee_product)
    return if !is_a_coffee_product && coffee_params["coffee"] == "true" && coffee_params["comment"].present?

    purchase.create_review!(comment: coffee_params["comment"])
    purchase.user.update_name!(coffee_params["giver_name"])
  end

  def compute_net_amount_for_each_line_item
    net_amount_for_item1 = (@session.line_items.data[0].amount_total * (1 - stripe_fee_proportion)).to_i
    total_net = @balance_transaction.net

    [ net_amount_for_item1, (total_net - net_amount_for_item1) ]
  end

  def stripe_fee_proportion
    @balance_transaction.fee.to_f / @balance_transaction.amount.to_f
  end

  def customer
    @_customer ||= User.find_or_initialize_by(email: @session.customer_details.email)
  end

  def header(event)
    { stripe_account: event.account }
  end
end
