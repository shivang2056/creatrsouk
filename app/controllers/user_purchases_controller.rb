class UserPurchasesController < ApplicationController

  def index
    @bought_products = current_user.purchases.map(&:product)
  end

  def create
    product = Product.find(params[:product_id])
    account = product.user.account

    checkout_session = Stripe::Checkout::Session.create({
      customer_email: current_user.email,
      mode: 'payment',
      success_url: user_purchases_url,
      cancel_url: product_url(product),
      line_items: [{
        price: product.stripe_price_id,
        quantity: 1,
      }]
    }, {
      stripe_account: account.stripe_id,
    })

    redirect_to checkout_session.url, allow_other_host: true, status: :see_other
  end
end
