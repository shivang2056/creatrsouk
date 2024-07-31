require 'test_helper'

class EventJobTest < ActiveJob::TestCase
  setup do
    @account = accounts(:account1)
    @stripe_event_data = {
      id: 'evt_123',
      data: {
        object: {
          id: @account.stripe_id,
          charges_enabled: true,
          payouts_enabled: false,
          details_submitted: true
        }
      },
      type: 'account.updated'
    }
  end

  test 'should handle stripe account.updated event' do
    event = create_event

    perform_enqueued_jobs do
      EventJob.perform_later(event)
    end

    @account.reload

    assert_equal true, @account.charges_enabled
    assert_equal false, @account.payouts_enabled
    assert_equal true, @account.details_submitted
  end

  test 'should handle stripe checkout session completed events' do
    @stripe_event_data[:type] = 'checkout.session.completed'
    event = create_event

    CheckoutComplete::Processor.expects(:process).with(instance_of(Stripe::Event))

    perform_enqueued_jobs do
      EventJob.perform_later(event)
    end
  end

  private

  def create_event
    Event.create!(source: 'stripe', data: @stripe_event_data)
  end
end
