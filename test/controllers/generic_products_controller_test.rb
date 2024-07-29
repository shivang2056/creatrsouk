require "test_helper"

class GenericProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user1)
    @product = products(:product1)
    @product.image.attach(fixture_file_upload("image.jpeg"))
    @product.update(average_rating: @product.reviews.average(:rating).to_f.round(2))
    @params = {
      generic_product: {
        name: "New Product", price: 10,
        active: true, description: "New Product",
        image: fixture_file_upload("image.jpeg")
      }
    }

    sign_in @user
  end

  test "should get index" do
    get generic_products_url

    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should show product" do
    get generic_product_url(@product)

    assert_response :success
    assert_not_nil assigns(:rating_decorator)
  end

  test "should get new" do
    get new_generic_product_url

    assert_response :success
  end

  test "should get edit" do
    get edit_generic_product_url(@product)

    assert_response :success
  end

  test "should create product" do
    assert_difference("GenericProduct.count") do
      post generic_products_url, params: @params
    end

    assert_redirected_to edit_generic_product_url(GenericProduct.last)
    assert_equal "Product was successfully created.", flash[:notice]
  end

  test "should not create product with invalid params" do
    assert_no_difference("GenericProduct.count") do
      post generic_products_url, params: { generic_product: { name: nil } }
    end

    assert_template :new
    assert_response :unprocessable_entity
  end

  test "should sync created product to stripe" do
    assert_enqueued_with(job: StripeProductJob) do
      post generic_products_url, params: @params
    end
  end

  test "should update product" do
    patch generic_product_url(@product), params: { generic_product: { name: "Updated Name" } }

    assert_redirected_to edit_generic_product_url(@product)
    assert_equal "Product was successfully updated.", flash[:notice]
    assert_equal "Updated Name", @product.reload.name
  end

  test "should not update product with invalid params" do
    patch generic_product_url(@product), params: { generic_product: { name: nil } }

    assert_template :edit
    assert_response :unprocessable_entity
  end

  test "should sync updated product to stripe" do
    assert_enqueued_with(job: StripeProductJob) do
      patch generic_product_url(@product), params: { generic_product: { name: "Updated Name" } }
    end
  end

  test "should get reviews" do
    get reviews_generic_product_url(@product)

    assert_response :success
  end

  test "should get user products" do
    get my_products_generic_products_url

    assert_response :success
    assert_not_nil assigns(:products)
  end
end
