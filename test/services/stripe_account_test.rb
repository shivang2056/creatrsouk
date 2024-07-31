require 'test_helper'
require 'mocha/minitest'

class StripeAccountTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @account = accounts(:account1)
    @service = StripeAccount.new(@account)
  end

  test 'initializes with an account' do
    assert_equal @account, @service.account
  end

  test 'creates a stripe account if stripe_id not present' do
    @account.update(stripe_id: nil)
    Stripe::Account.expects(:create).with(instance_of(Hash)).returns(
      Stripe::StripeObject.construct_from({
        id: 'test_stripe_id',
        object: 'account'
      })
    )

    assert_nothing_raised { @service.create_account }
    assert_equal 'test_stripe_id', @account.stripe_id
    refute_nil @account.stripe_id
  end

  test 'generates a valid onboarding link if stripe_id not present' do
    Stripe::AccountLink.expects(:create).with(instance_of(Hash)).returns(
      Stripe::StripeObject.construct_from({
        url: 'http://test.com/onboarding'
      })
    )

    url = @service.onboarding_url
    assert_includes url, 'http://test.com/onboarding'
  end

  test "doesn't attempt to create stripe account if stripe_id present" do
    @account.update(stripe_id: 'test_stripe_id')
    service = StripeAccount.new(@account)

    Stripe::Account.expects(:create).never

    assert_nothing_raised { service.create_account }
    assert_equal 'test_stripe_id', @account.stripe_id
  end

  test 'generates a valid onboarding link if stripe_id present' do
    @account.update(stripe_id: 'test_stripe_id')
    service = StripeAccount.new(@account)

    Stripe::AccountLink.expects(:create).with(instance_of(Hash)).returns(
      Stripe::StripeObject.construct_from({
        url: 'http://test.com/onboarding'
      })
    )

    url = service.onboarding_url
    assert_includes url, 'http://test.com/onboarding'
  end
end
