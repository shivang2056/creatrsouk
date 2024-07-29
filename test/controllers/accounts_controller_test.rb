require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user1)
    sign_in @user
    @account = accounts(:account1)
  end

  test "should get show" do
    get account_url(@account)

    assert_response :success
  end

  test "should handle create when account does not have a stripe_id" do
    stripe_service = StripeAccount.new(@account)

    StripeAccount.expects(:new).with(@account).returns(stripe_service)
    stripe_service.expects(:create_account)
    stripe_service.expects(:onboarding_url).returns('http://test.com/onboarding')

    post account_url(@account)

    assert_redirected_to 'http://test.com/onboarding'
    assert_response :see_other
  end

  test "should handle create when account already has a stripe_id" do
    @account.update(stripe_id: 'existing_stripe_id')
    stripe_service = StripeAccount.new(@account)

    StripeAccount.expects(:new).with(@account).returns(stripe_service)
    stripe_service.expects(:onboarding_url).returns('http://test.com/onboarding')

    post account_url(@account)

    assert_redirected_to 'http://test.com/onboarding'
    assert_response :see_other
  end
end
