class StripeCheckout
  include Rails.application.routes.url_helpers

  attr_reader :stripe_id, :product, :coffee_params, :current_user

  def initialize(stripe_id, product: nil, coffee_params: {}, current_user: nil)
    @stripe_id = stripe_id
    @product = product
    @coffee_params = coffee_params
    @current_user = current_user
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  def create_session(platform_user: true)
    payload = base_payload(platform_user)

    payload[:line_items] << product_line_item if @product.present?

    if @coffee_params[:tip_amount].to_i > 0
      payload[:line_items] << coffee_line_item
      payload[:metadata] = {
        giver_name: @coffee_params[:tip_giver_name],
        tip_comment: @coffee_params[:tip_comment]
      }
    end

    return nil if payload[:line_items].blank?

    Stripe::Checkout::Session.create(payload, header)
  end

  def base_payload(platform_user)
    {
      customer_email: @current_user && @current_user.full_name,
      mode: 'payment',
      success_url: success_url(platform_user),
      cancel_url: cancel_url(platform_user),
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
          name: @coffee_params[:tip_name]
        },
        unit_amount: @coffee_params[:tip_amount].to_i * 100
      },
      quantity: 1
    }
  end

  def success_url(platform_user)
    if platform_user
      user_purchases_url
    else
      store_checkout_url + "?session_id={CHECKOUT_SESSION_ID}"
    end
  end

  def cancel_url(platform_user)
    if platform_user
      @product.present? ? product_url(@product) : root_url
    else
      @product.present? ? store_product_url(@product) : store_root_url
    end
  end

  def header
    { stripe_account: @stripe_id }
  end
end
