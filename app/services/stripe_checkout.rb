class StripeCheckout
  attr_reader :stripe_id, :product, :coffee_params, :current_user

  def initialize(stripe_id:, product: nil, coffee_params: {}, success_url:, cancel_url:, current_user: nil)
    @stripe_id = stripe_id
    @product = product
    @user = @product.user
    @coffee_params = coffee_params
    @success_url = success_url
    @cancel_url = cancel_url
    @current_user = current_user
  end

  def create_session
    payload = base_payload

    payload[:line_items] << line_item if @product.present?

    if @coffee_params[:quantity].to_i > 0
      payload[:metadata] = {
        coffee: true,
        giver_name: @coffee_params[:contributor_name],
        comment: @coffee_params[:comment]
      }

      payload[:line_items] << line_item(coffee: true)
    end

    return nil if payload[:line_items].blank?

    Stripe::Checkout::Session.create(payload, header)
  end

  def base_payload
    {
      customer_email: @current_user && @current_user.email,
      mode: 'payment',
      success_url: @success_url,
      cancel_url: @cancel_url,
      line_items: []
    }
  end

  def line_item(coffee: false)
    {
      price: line_item_stripe_price_id(coffee),
      quantity: line_item_quantity(coffee)
    }
  end

  def line_item_stripe_price_id(coffee)
    coffee ? @user.coffee_product.stripe_price_id : @product.stripe_price_id
  end

  def line_item_quantity(coffee)
    coffee ? @coffee_params[:quantity].to_i : 1
  end

  def header
    { stripe_account: @stripe_id }
  end
end
