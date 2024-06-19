class UserPurchasesController < ApplicationController

  def index
    @user_purchases = current_user
                        .purchases
                        .includes(product: [:user, image_attachment: :blob])
  end

  def create
    product = Product.find(create_params[:product_id])
    service = StripeCheckout.new(
                product.user.account.stripe_id,
                product: product,
                coffee_params: create_params.except(:product_id),
                current_user: current_user
              )

    checkout_session = service.create_session

    redirect_to checkout_session.url, allow_other_host: true, status: :see_other
  end

  def show
    @user_purchase = current_user.purchases
                      .includes(product: [:user, attachments: [file_attachment: :blob]])
                      .find(params[:id])
    # TODO: Remove this
    # @user_purchase = UserPurchase.includes(product: [:user, attachments: [file_attachment: :blob]]).find(1013815665)
    @product = @user_purchase.product
    @attachment_decorator = AttachmentDecorator.decorate(@product)
    @receipt_url = @user_purchase.receipt_url
  end

  private

  def create_params
    params.permit(:product_id, :tip_name, :tip_amount, :tip_giver_name, :tip_comment)
  end
end
