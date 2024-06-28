class UserPurchasesController < ApplicationController

  def index
    @user_purchases = current_user
                        .purchases
                        .includes(product: [:user, image_attachment: :blob])

  end

  def create
    product = Product.find(create_params[:generic_product_id])
    service = StripeCheckout.new(
                stripe_id: product.user.account.stripe_id,
                product: product,
                coffee_params: create_params[:coffee_attributes],
                success_url: user_purchases_url,
                cancel_url: generic_product_url(product),
                current_user: current_user
              )

    checkout_session = service.create_session

    redirect_to checkout_session.url, allow_other_host: true, status: :see_other
  end

  def show
    @user_purchase = current_user.purchases
                      .includes(product: [:user, attachments: [file_attachment: :blob]])
                      .find(params[:id])

    @coffee_purchase = current_user
                        .given_coffees
                        .find_by_checkout_session_id(@user_purchase.checkout_session_id)
    # TODO: Remove this
    # @user_purchase = UserPurchase.includes(product: [:user, attachments: [file_attachment: :blob]]).find(1013815665)
    @product = @user_purchase.product
    @attachment_decorator = AttachmentDecorator.decorate(@product)
    @receipt_url = @user_purchase.receipt_url
  end

  private

  def create_params
    params.permit(:generic_product_id, coffee_attributes: [:quantity, :contributor_name, :comment])
  end
end
