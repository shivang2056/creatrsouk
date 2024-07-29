require 'test_helper'

module Stores
  class CheckoutsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      @store = stores(:store1)
      @product = products(:product1)
      @product.image.attach(fixture_file_upload("image.jpeg"))
      @attachment = @product.attachments.last
      @attachment.file.attach(fixture_file_upload('sample.txt'))
      @user_purchase = user_purchases(:purchase1)
      @coffee_purchase = user_purchases(:coffee_purchase1)
      @user = users(:user2)
      Store.stubs(:find_by_request).returns(@store)

      sign_in @user
    end

    test "should get new_coffee" do
      get new_coffee_store_checkout_url

      assert_response :success
    end

    test "should show purchase details" do
      [@user_purchase, @coffee_purchase].each do |purchase|
        purchase.update(checkout_session_id: 'checkout_session_id_1234', receipt_url: 'http://example.com/receipt')
      end

      get store_checkout_url, params: { session_id: 'checkout_session_id_1234' }

      assert_response :success
      assert_not_nil assigns(:user_purchase)
      assert_not_nil assigns(:coffee_purchase)
      assert_equal @user_purchase.receipt_url, assigns(:receipt_url)
    end

    test "should initiate purchase and redirect to checkout session" do
      stripe_service = StripeCheckout.new(
        author: @store.user,
        product: @product,
        coffee_params: { quantity: 2, contributor_name: "First Last", comment: "TestComment123" },
        success_url: store_checkout_url + "?session_id={CHECKOUT_SESSIONID}",
        cancel_url: store_product_url(@product)
      )

      StripeCheckout.expects(:new).returns(stripe_service)

      stripe_service.expects(:create_session).returns(
        Stripe::StripeObject.construct_from({
          url: 'http://example.com/checkout'
        })
      )

      post store_checkout_url, params: { generic_product_id: @product.id, coffee_attributes: { quantity: 2, contributor_name: "First Last", comment: "TestComment123" } }

      assert_redirected_to "http://example.com/checkout"
    end
  end
end
