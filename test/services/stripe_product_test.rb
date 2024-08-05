require 'test_helper'

class StripeProductTest < ActiveSupport::TestCase
  setup do
    @product = products(:product1)
    @product.image.attach(file_fixture('image.jpeg'))

    @stripe_product = StripeProduct.new(@product)
  end

  test "should not create product if stripe_id is present" do
    @product.stripe_id = "some_stripe_id"
    Stripe::Product.expects(:create).never

    @stripe_product.create_product
  end

  test "should create product if stripe_id is not present" do
    @product.stripe_id = nil
    stripe_product = Stripe::Product.construct_from({id: 'new_stripe_product_id', default_price: { id: 'default_price_id' }})

    Stripe::Product.expects(:create).with(
      {
        name: @product.name,
        description: @product.description,
        images: [nil],
        metadata: {
          user_id: @product.user_id,
          product_id: @product.id
        },
        default_price_data: {
          currency: 'USD',
          unit_amount: (@product.price.to_f * 100).to_i
        },
        expand: ['default_price']
      },
      stripe_header
    ).returns(stripe_product)

    @stripe_product.create_product

    assert_equal 'new_stripe_product_id', @product.stripe_id
    assert_equal 'default_price_id', @product.stripe_price_id
  end

  test "should not update product in stripe if stripe_id is not present" do
    @product.stripe_id = nil
    Stripe::Product.expects(:update).never

    @stripe_product.update_product(false)
  end

  test "should update product in stripe if stripe_id is present" do
    @product.update(stripe_id: 'existing_stripe_id')
    stripe_product = Stripe::Product.construct_from({id: 'new_stripe_product_id', default_price: { id: 'default_price_id' }})

    Stripe::Product.expects(:update).with(
      @product.stripe_id,
      {
        name: @product.name,
        description: @product.description,
        images: [nil]
      },
      stripe_header
    ).returns(stripe_product)

    @stripe_product.update_product(false)
    expected = {"id"=>"new_stripe_product_id", "default_price"=>{"id"=>"default_price_id"}}

    assert_equal expected, JSON.parse(@product.data)
  end

  test "should update price if price_update is true" do
    @product.update(stripe_id: 'existing_stripe_id')
    stripe_price = Stripe::Price.construct_from({id: 'new_price_id'})

    Stripe::Product.expects(:update)
    Stripe::Price.expects(:create).with(
      {
        product: @product.stripe_id,
        currency: 'usd',
        unit_amount: (@product.price.to_f * 100).to_i
      },
      stripe_header
    ).returns(stripe_price)

    @stripe_product.update_product(true)

    assert_equal 'new_price_id', @product.stripe_price_id
  end

  private

  def stripe_header
    { stripe_account: @product.user.account.stripe_id }
  end
end
