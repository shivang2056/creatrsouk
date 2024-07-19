module Stores
  class CheckoutsController < BaseController

    def new_coffee
      render turbo_stream: [
        turbo_stream_update("modal", "new_coffee",
          {
            coffee_product: @store.coffee_product,
            user_purchases: @store.coffee_product
                                  .user_purchases
                                  .includes(:user, :review)
          }
        )
      ]
    end

    def show
      @user_purchase = UserPurchase
                        .generic_purchases
                        .includes(product: [:user, attachments: [file_attachment: :blob]])
                        .find_by_checkout_session_id(params[:session_id])

      @coffee_purchase = UserPurchase
                            .coffee_purchases
                            .find_by_checkout_session_id(params[:session_id])

      @receipt_url = (@user_purchase || @coffee_purchase).receipt_url

      if @user_purchase.present?
        @product = @user_purchase.product
        @attachment_decorator = AttachmentDecorator.decorate(@product)
      end
    end

    def create
      product = Product.find_by_id(create_params[:generic_product_id])

      service = StripeCheckout.new(
                  author: @store.user,
                  product: product,
                  coffee_params: create_params[:coffee_attributes],
                  success_url: store_checkout_url + "?session_id={CHECKOUT_SESSION_ID}",
                  cancel_url: product.present? ? store_product_url(product) : store_root_url,
                )

      checkout_session = service.create_session

      redirect_to checkout_session.url, allow_other_host: true, status: :see_other
    end

    private

    def create_params
      params.permit(:generic_product_id, coffee_attributes: [:quantity, :contributor_name, :comment])
    end
  end
end
