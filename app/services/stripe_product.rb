class StripeProduct
  attr_reader :product

  def initialize(product)
    @product = product
  end

  def create_product
    return if product.stripe_id.present?

    stripe_product = Stripe::Product.create(product_params, stripe_header)
    update_product_attributes(stripe_product)
  end

  def update_product(price_update)
    return unless product.stripe_id.present?

    stripe_product = Stripe::Product.update(product.stripe_id, update_params, stripe_header)
    product.update!(data: stripe_product.to_json)

    update_price(price_update) if price_update
  end

  private

  def product_params
    {
      name: product.name,
      description: product.description,
      metadata: product_metadata,
      default_price_data: price_data,
      expand: ['default_price']
    }
  end

  def update_params
    {
      name: product.name,
      description: product.description
    }
  end

  def product_metadata
    {
      user_id: product.user_id,
      product_id: product.id
    }
  end

  def price_data
    {
      currency: 'USD',
      unit_amount: unit_amount
    }
  end

  def unit_amount
    (product.price.to_f * 100).to_i
  end

  def update_product_attributes(stripe_product)
    product.update!(
      stripe_id: stripe_product.id,
      data: stripe_product.to_json,
      stripe_price_id: stripe_product.default_price.id,
    )
  end

  def update_price(price_update)
    stripe_price = Stripe::Price.create(price_params, stripe_header)
    product.update!(stripe_price_id: stripe_price.id)
  end

  def price_params
    {
      product: product.stripe_id,
      currency: 'usd',
      unit_amount: unit_amount
    }
  end

  def stripe_header
    { stripe_account: product.user.account.stripe_id }
  end
end
