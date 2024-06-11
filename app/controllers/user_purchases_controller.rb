class UserPurchasesController < ApplicationController

  def index
    @user_purchases = current_user
                        .purchases
                        .includes(product: [:user, image_attachment: :blob])
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

  def show
    user_purchase = UserPurchase
                      .includes(product: [:user, attachments: [file_attachment: :blob]])
                      .find(params[:id])
    # TODO: Remove this
    # user_purchase = UserPurchase.includes(product: [:user, attachments: [file_attachment: :blob]]).find(1013815665)
    @product = user_purchase.product

    if @product.user&.account&.stripe_id.present?
      checkout_session = Stripe::Checkout::Session.retrieve({
        id: user_purchase.checkout_session_id,
        expand: ['payment_intent.latest_charge']
      }, {
        stripe_account: @product.user.account&.stripe_id
      })

      @receipt_url = checkout_session.payment_intent.latest_charge.receipt_url
    end
  end
end
