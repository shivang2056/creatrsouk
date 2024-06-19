class StripeCheckout
  include Rails.application.routes.url_helpers

  attr_reader :stripe_id, :product, :coffee_params, :current_user

  def initialize(stripe_id:, product: nil, coffee_params: {}, success_url:, cancel_url:, current_user: nil)
    @stripe_id = stripe_id
    @product = product
    @coffee_params = coffee_params
    @success_url = success_url
    @cancel_url = cancel_url
    @current_user = current_user
  end

  def create_session
    payload = base_payload

    payload[:line_items] << product_line_item if @product.present?
    payload[:line_items] << coffee_line_item if @coffee_params[:tip_amount].to_i > 0

    return nil if payload[:line_items].blank?

    Stripe::Checkout::Session.create(payload, header)
  end

  def base_payload
    {
      customer_email: @current_user && @current_user.full_name,
      mode: 'payment',
      success_url: @success_url,
      cancel_url: @cancel_url,
      line_items: []
    }
  end

  def product_line_item
    {
      price: @product.stripe_price_id,
      quantity: 1
    }
  end

  def coffee_line_item
    {
      price_data: {
        currency: 'usd',
        product_data: {
          name: "Coffee for #{@product.user.full_name}",
          metadata: {
            coffee: true,
            giver_name: @coffee_params[:tip_giver_name],
            comment: @coffee_params[:tip_comment]
          }
        },
        unit_amount: @coffee_params[:tip_amount].to_i * 100
      },
      quantity: 1
    }
  end

  def header
    { stripe_account: @stripe_id }
  end
end
