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
        unit_amount: (product.price.to_f * 100).to_i
      },
      expand: ['default_price']
    }, header)

    product.update!(
      stripe_id: stripe_product.id,
      data: stripe_product.to_json,
      stripe_price_id: stripe_product.default_price.id,
    )
  end

  def update_product(price_update)
    return unless product.stripe_id.present?

    stripe_product = Stripe::Product.update(
      product.stripe_id,
      {
        name: product.name,
        description: product.description
      },
      header
    )

    product.data = stripe_product.to_json

    if price_update
      stripe_price = Stripe::Price.create(
        {
          product: product.stripe_id,
          currency: 'usd',
          unit_amount: (product.price.to_f * 100).to_i
        },
        header
      )

      product.stripe_price_id = stripe_price.id
    end

    product.save!
  end

  private

  def header
    { stripe_account: product.user.account.stripe_id }
  end
end
