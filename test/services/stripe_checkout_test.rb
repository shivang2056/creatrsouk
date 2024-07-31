require 'test_helper'

class StripeCheckoutTest < ActiveSupport::TestCase
  setup do
    @product = products(:product1)
    @product.update_column(:stripe_price_id, 'product1_stripe_price_id')
    @coffee_product = products(:coffee_product1)
    @coffee_product.update_column(:stripe_price_id, 'coffee_product_stripe_price_id')
    @coffee_params = { quantity: 2, contributor_name: 'First Last', comment: 'test comment' }
    @current_user = users(:user2)
    @success_url = 'http://example.com/success'
    @cancel_url = 'http://example.com/cancel'
  end

  test 'create_session creates a Stripe session without coffee params' do
    Stripe::Checkout::Session.expects(:create).with(
      {
        customer_email: @current_user.email,
        mode: 'payment',
        success_url: @success_url,
        cancel_url: @cancel_url,
        line_items: [
          {
            price: 'product1_stripe_price_id',
            quantity: 1
          }
        ]
      },
      {
        stripe_account: @product.user.account.stripe_id
      }
    ).returns(
      Stripe::Checkout::Session.construct_from({id: 'stripe_checkout_session_id'})
    )

    assert_equal 'stripe_checkout_session_id', stripe_checkout.create_session.id
  end

  test 'create_session creates a Stripe session with coffee params' do
    Stripe::Checkout::Session.expects(:create).with(
      {
        customer_email: @current_user.email,
        mode: 'payment',
        success_url: @success_url,
        cancel_url: @cancel_url,
        metadata: {
          coffee: true,
          giver_name: 'First Last',
          comment: 'test comment'
        },
        line_items: [
          {
            price: 'product1_stripe_price_id',
            quantity: 1
          },
          {
            price: 'coffee_product_stripe_price_id',
            quantity: 2
          }
        ]
      },
      {
        stripe_account: @product.user.account.stripe_id
      }
    ).returns(
      Stripe::Checkout::Session.construct_from({id: 'stripe_checkout_session_id'})
    )

    assert_equal 'stripe_checkout_session_id', stripe_checkout(@coffee_params).create_session.id
  end

  test 'create_session does not consider coffee_params if coffee_params quantity < 1' do
    @coffee_params[:quantity] = 0

    Stripe::Checkout::Session.expects(:create).with(
      {
        customer_email: @current_user.email,
        mode: 'payment',
        success_url: @success_url,
        cancel_url: @cancel_url,
        metadata: {
          coffee: true,
          giver_name: 'First Last',
          comment: 'test comment'
        },
        line_items: [
          {
            price: 'product1_stripe_price_id',
            quantity: 1
          },
          {
            price: 'coffee_product_stripe_price_id',
            quantity: 2
          }
        ]
      },
      {
        stripe_account: @product.user.account.stripe_id
      }
    ).never

    Stripe::Checkout::Session.expects(:create).with(
      {
        customer_email: @current_user.email,
        mode: 'payment',
        success_url: @success_url,
        cancel_url: @cancel_url,
        line_items: [
          {
            price: 'product1_stripe_price_id',
            quantity: 1
          }
        ]
      },
      {
        stripe_account: @product.user.account.stripe_id
      }
    ).returns(
      Stripe::Checkout::Session.construct_from({id: 'stripe_checkout_session_id'})
    )

    assert_equal 'stripe_checkout_session_id', stripe_checkout(@coffee_params).create_session.id
  end

  private

  def stripe_checkout(coffee_params = {})
    StripeCheckout.new(
      author: @product.user,
      product: @product,
      coffee_params: coffee_params,
      success_url: @success_url,
      cancel_url: @cancel_url,
      current_user: @current_user
    )
  end
end
