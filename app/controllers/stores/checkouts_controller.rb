module Stores
  class CheckoutsController < BaseController

    def show
      @user_purchase = UserPurchase
                        .includes(product: [:user, attachments: [file_attachment: :blob]])
                        .find_by_checkout_session_id(params[:session_id])

      @product = @user_purchase.product
      @attachment_decorator = AttachmentDecorator.decorate(@product)
      @receipt_url = @user_purchase.receipt_url
    end

    def create
      product = Product.find(params[:product_id])

      checkout_session = Stripe::Checkout::Session.create({
        mode: 'payment',
        success_url: store_checkout_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: store_product_url(product),
        line_items: [{
          price: product.stripe_price_id,
          quantity: 1
        }]
      }, {
        stripe_account: @store.user.account.stripe_id
      })

      redirect_to checkout_session.url, allow_other_host: true, status: :see_other
    end
  end
end
