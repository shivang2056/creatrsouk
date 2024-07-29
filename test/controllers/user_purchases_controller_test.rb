require 'test_helper'

class UserPurchasesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user2)
    @product = products(:product1)
    @product.image.attach(fixture_file_upload("image.jpeg"))
    @attachment = @product.attachments.last
    @attachment.file.attach(fixture_file_upload('sample.txt'))
    @purchase = user_purchases(:purchase1)
    @coffee_purchase = user_purchases(:coffee_purchase1)

    sign_in @user
  end

  test "should get index" do
    get user_purchases_url
    assert_response :success
    assert_not_nil assigns(:user_purchases)
  end

  test "should initiate purchase and redirect to checkout session" do
    stripe_service = StripeCheckout.new(
      author: @product.user,
      product: @product,
      coffee_params: { quantity: 2, contributor_name: "First Last", comment: "TestComment123" },
      success_url: user_purchases_url,
      cancel_url: generic_product_url(@product),
      current_user: @user
    )

    StripeCheckout.expects(:new).returns(stripe_service)

    stripe_service.expects(:create_session).returns(
      Stripe::StripeObject.construct_from({
        url: 'http://example.com/checkout'
      })
    )

    post user_purchases_url, params: { generic_product_id: @product.id, coffee_attributes: { quantity: 2, contributor_name: "First Last", comment: "TestComment123" } }

    assert_redirected_to "http://example.com/checkout"
  end

  test "should show purchase" do
    [@purchase, @coffee_purchase].each do |purchase|
      purchase.update(checkout_session_id: 'checkout_session_id_1234', receipt_url: 'http://example.com/receipt')
    end

    get user_purchase_url(@purchase)

    assert_response :success

    assert_not_nil assigns(:user_purchase)
    assert_not_nil assigns(:coffee_purchase)
    assert_not_nil assigns(:product)
    assert_not_nil assigns(:attachment_decorator)
    assert_not_nil assigns(:receipt_url)
  end
end
