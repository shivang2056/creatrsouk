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
      product = Product.find(create_params[:product_id])

      service = StripeCheckout.new(
                  @store.user.account.stripe_id,
                  product: product,
                  coffee_params: create_params.except(:product_id)
                )

      checkout_session = service.create_session

      redirect_to checkout_session.url, allow_other_host: true, status: :see_other
    end

    private

    def create_params
      params.permit(:product_id, :tip_name, :tip_amount, :tip_giver_name, :tip_comment)
    end
  end
end
