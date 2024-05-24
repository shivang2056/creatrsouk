class StripeProduct
  attr_reader :product

  def initialize(product)
    @product = product
  end

  def create_product
    return if product.stripe_id.present?

    stripe_product = Stripe::Product.create({
      name: product.name,
      description: product.description,
      metadata: {
        user_id: product.user_id,
        product_id: product.id
      },
      default_price_data: {
        currency: 'USD',
        unit_amount: (@product.price.to_f * 100).to_i
      },
      expand: ['default_price']
    }, {
      stripe_account: product.user.account.stripe_id
    })

    product.update(
      stripe_id: stripe_product.id,
      data: stripe_product.to_json,
      stripe_price_id: stripe_product.default_price.id,
    )
  end
end
