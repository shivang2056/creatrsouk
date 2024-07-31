module CheckoutComplete
  class SessionManager
    def initialize(stripe_event)
      @stripe_event = stripe_event
    end

    def retrieve_session
      Stripe::Checkout::Session.retrieve({
        id: @stripe_event.data.object.id,
        expand: additional_session_details
      }, header)
    end

    private

    def additional_session_details
      ['line_items.data.price.product', 'payment_intent.latest_charge.balance_transaction']
    end

    def header
      { stripe_account: @stripe_event.account }
    end
  end
end
