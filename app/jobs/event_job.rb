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
      CheckoutComplete.process(stripe_event)
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
end
