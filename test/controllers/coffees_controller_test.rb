require 'test_helper'

class CoffeesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user1)
    @user2 = users(:user2)
    @coffee_product = products(:coffee_product1)

    sign_in @user
  end

  test "should get show" do
    get coffee_path(@coffee_product)

    assert_response :success
    assert_not_nil assigns(:decorated_coffee)
  end

  test "should update coffee widget successfully" do
    patch coffee_path(@coffee_product), params: { coffee_product: { price: 1212 } }

    assert_redirected_to coffee_path
    assert_equal 'Coffee Widget updated.', flash[:notice]

    @coffee_product.reload

    assert_equal 1212, @coffee_product.price
  end

  test "should not update coffee widget with invalid params" do
    patch coffee_path(@coffee_product), params: { coffee_product: { price: nil } }

    assert_template :show

    assert_not_nil @coffee_product.price
  end

  test "should initialize new coffee product if none exists" do
    sign_in @user2

    get coffee_path

    assert_response :success
    assert_not_nil assigns(:coffee_widget)

    assert_equal "Coffee for #{@user2.full_name}", assigns(:coffee_widget).name
  end

  test "should sync updated coffee widget to stripe" do
    assert_enqueued_with(job: StripeProductJob) do
      patch coffee_path(@coffee_product), params: { coffee_product: { price: 3 } }
    end
  end
end

