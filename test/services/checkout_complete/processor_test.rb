require 'test_helper'

module CheckoutComplete
  class ProcessorTest < ActiveSupport::TestCase
    setup do
      @stripe_event = Stripe::Event.construct_from({})
      @session = Stripe::Checkout::Session.construct_from(
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

    test 'should retrieve session and process payment for valid stripe event' do
      session_manager = SessionManager.new(@stripe_event)
      payment_processor = PaymentProcessor.new(@session)

      SessionManager.expects(:new).with(@stripe_event).returns(session_manager)
      session_manager.expects(:retrieve_session).returns(@session).once
      PaymentProcessor.expects(:new).with(@session).returns(payment_processor).once
      payment_processor.expects(:process).once

      Processor.process(@stripe_event)
    end
  end
end
