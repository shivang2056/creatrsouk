class EventJob < ApplicationJob
  queue_as :default

  def perform(event)
    case event.source
    when 'stripe'
      handle_stripe_event(event)
    end
  end

  private

  def handle_stripe_event(event)
    stripe_event = Stripe::Event.construct_from(event.data)

    case stripe_event.type
    when 'account.updated'
      handle_account_updated(stripe_event)
    when 'checkout.session.completed'
      handle_checkout_session_completed(stripe_event)
    end
  end

  def handle_account_updated(stripe_event)
    stripe_account = stripe_event.data.object
    account = Account.find_by(stripe_id: stripe_account.id)
    account.update(
      charges_enabled: stripe_account.charges_enabled,
      payouts_enabled: stripe_account.payouts_enabled,
      details_submitted: stripe_account.details_submitted
    )
  end

  def handle_checkout_session_completed(stripe_event)
    session = retrieve_stripe_checkout_session(stripe_event)

    return if session.payment_status != 'paid'

    product = Product.find_by(stripe_id: session.line_items.data[0].price.product)

    update_customer_purchases(session, product)
    update_product_financials(session, product)
  end

  def retrieve_stripe_checkout_session(stripe_event)
    Stripe::Checkout::Session.retrieve({
      id: stripe_event.data.object.id,
      expand: ['line_items', 'payment_intent.latest_charge.balance_transaction']
    }, header(stripe_event))
  end

  def update_customer_purchases(session, product)
    customer = User.find_or_initialize_by(email: session.customer_details.email)

    customer.update!(customer: true, password: SecureRandom.uuid) unless customer.persisted?

    customer.purchases.create(product: product,
      price: product.price,
      checkout_session_id: session.id,
      receipt_url: session.payment_intent.latest_charge.receipt_url
    )
  end

  def update_product_financials(session, product)
    net_amount = session.payment_intent.latest_charge.balance_transaction.net

    financial = product.financial || product.build_financial(user: product.user, sales: 0, revenue: 0)
    financial.revenue += ( net_amount / 100.00)
    financial.sales += 1
    financial.save!
  end

  def header(event)
    { stripe_account: event.account }
  end
end
