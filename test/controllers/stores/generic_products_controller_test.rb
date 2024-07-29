require 'test_helper'

module Stores
  class GenericProductsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      @store = stores(:store1)
      @product = products(:product1)
      @product.image.attach(fixture_file_upload("image.jpeg"))
      @product.update(average_rating: @product.reviews.average(:rating).to_f.round(2))
      Store.stubs(:find_by_request).returns(@store)

      sign_in users(:user1)
    end

    test "should get index" do
      get store_products_url

      assert_response :success
      assert_not_nil assigns(:products)
    end

    test "should show product" do
      get store_product_url(@product)

      assert_response :success
      assert_not_nil assigns(:product)
      assert_not_nil assigns(:rating_decorator)
    end

    test "should get reviews for product" do
      get reviews_store_product_url(@product)

      assert_response :success
      assert_not_nil assigns(:product)
    end
  end
end
