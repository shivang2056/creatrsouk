module Stores
  class CheckoutsController < BaseController

    def new_coffee
      render turbo_stream: [
        turbo_stream.update("modal",
          partial: "new_coffee")
      ]
    end

    def show
      @user_purchase = UserPurchase
                        .includes(product: [:user, attachments: [file_attachment: :blob]])
                        .find_by_checkout_session_id(params[:session_id])

      @product = @user_purchase.product
      @attachment_decorator = AttachmentDecorator.decorate(@product)
      @receipt_url = @user_purchase.receipt_url
    end

    def create
      product = Product.find_by_id(create_params[:generic_product_id])

      service = StripeCheckout.new(
                  stripe_id: @store.user.account.stripe_id,
                  product: product,
                  coffee_params: create_params.except(:generic_product_id),
                  success_url: store_checkout_url + "?session_id={CHECKOUT_SESSION_ID}",
                  cancel_url: product.present? ? store_product_url(product) : store_root_url,
                )

      checkout_session = service.create_session

      redirect_to checkout_session.url, allow_other_host: true, status: :see_other
    end

    private

    def create_params
      params.permit(:generic_product_id, :tip_amount, :tip_giver_name, :tip_comment)
    end
  end
end
