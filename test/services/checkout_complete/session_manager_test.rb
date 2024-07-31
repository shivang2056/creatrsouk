require 'test_helper'

module CheckoutComplete
  class SessionManagerTest < ActiveSupport::TestCase
    setup do
      @stripe_event = Stripe::Event.construct_from(
        {
          account: 'stripe_account_id',
          data: {
            object: {
              id: 'stripe_object_id'
            }
          }
        }
      )
      @session_manager = SessionManager.new(@stripe_event)
    end

    test 'should retrieve session with correct parameters' do
      Stripe::Checkout::Session.expects(:retrieve).with({
        id: 'stripe_object_id',
        expand: ['line_items.data.price.product', 'payment_intent.latest_charge.balance_transaction']
      }, { stripe_account: 'stripe_account_id' }).returns(stub_session)

      result = @session_manager.retrieve_session

      assert_equal stub_session, result
    end

    private

    def stub_session
      Stripe::Checkout::Session.construct_from(
        {
          id: 'session_id',
          payment_intent: {
            latest_charge: {
              balance_transaction: {}
            }
          }
        }
      )
    end
  end
end
