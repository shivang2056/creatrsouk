require 'test_helper'

class StoresControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user1)
    @store = @user.store

    sign_in @user
  end

  test "should get show" do
    get store_url(@store)

    assert_response :success
    assert_not_nil assigns(:store)
  end

  test "should update store with valid parameters" do
    patch store_url(@store), params: { store: { subdomain: 'test321', background_color: '#FFFFFF', highlight_color: '#000000' } }

    assert_redirected_to store_path
    assert_equal 'Store details updated.', flash[:notice]

    @store.reload

    assert_equal 'test321', @store.subdomain
    assert_equal '#FFFFFF', @store.background_color
    assert_equal '#000000', @store.highlight_color
  end
end
