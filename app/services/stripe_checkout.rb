class StripeCheckout
  attr_reader :author, :stripe_id, :product, :coffee_params, :current_user

  def initialize(author:, product: nil, coffee_params: {}, success_url:, cancel_url:, current_user: nil)
    @author = author
    @product = product
    @coffee_params = coffee_params
    @success_url = success_url
    @cancel_url = cancel_url
    @current_user = current_user
  end

  def create_session
    payload = build_payload
    return nil if payload[:line_items].empty?

    Stripe::Checkout::Session.create(payload, stripe_account_header)
  end

  private

  def build_payload
    payload = base_payload

    add_product_line_item_to_payload(payload) if product
    add_coffee_line_item_to_payload(payload) if coffee_purchased?

    payload
  end

  def base_payload
    {
      customer_email: current_user&.email,
      mode: 'payment',
      success_url: @success_url,
      cancel_url: @cancel_url,
      line_items: []
    }
  end

  def add_product_line_item_to_payload(payload)
    payload[:line_items] << line_item_for_product
  end

  def add_coffee_line_item_to_payload(payload)
    payload[:metadata] = coffee_metadata
    payload[:line_items] << line_item_for_coffee
  end

  def line_item_for_product
    line_item(product.stripe_price_id, 1)
  end

  def line_item_for_coffee
    line_item(author.coffee_product.stripe_price_id, coffee_params[:quantity].to_i)
  end

  def line_item(price_id, quantity)
    { price: price_id, quantity: quantity }
  end

  def coffee_metadata
    {
      coffee: true,
      giver_name: coffee_params[:contributor_name],
      comment: coffee_params[:comment]
    }
  end

  def coffee_purchased?
    coffee_params[:quantity].to_i > 0
  end

  def stripe_account_header
    { stripe_account: author.account.stripe_id }
  end
end
