class UserPurchasesController < ApplicationController

  def index
    @user_purchases = current_user
                        .purchases
                        .includes(product: [:user, image_attachment: :blob])

  end

  def create
    product = Product.find(create_params[:generic_product_id])
    service = build_checkout_service(product)
    checkout_session = service.create_session

    redirect_to checkout_session.url, allow_other_host: true, status: :see_other
  end

  def show
    @user_purchase, @coffee_purchase = find_purchases_by_session_or_id

    @product = @user_purchase.product
    @receipt_url = @user_purchase.receipt_url
    @attachment_decorator = AttachmentDecorator.decorate(@product)
  end

  def checkout_complete
    @retries ||= 0

    show
    render 'show'
  rescue NoMethodError
    @retries += 1
    sleep 5
    retry if @retries < 10

    raise
  end

  private

  def build_checkout_service(product)
    StripeCheckout.new(
      author: product.user,
      product: product,
      coffee_params: create_params[:coffee_attributes] || {},
      success_url: checkout_complete_user_purchases_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: generic_product_url(product),
      current_user: current_user
    )
  end

  def find_purchases_by_session_or_id
    UserPurchase.uncached do
      generic_purchase = current_user
                          .purchases
                          .includes(product: [:user, attachments: [file_attachment: :blob]])
                          .find_by(session_or_id_param)
      coffee_purchase = current_user
                          .given_coffees
                          .find_by_checkout_session_id(generic_purchase.checkout_session_id)

      [ generic_purchase, coffee_purchase ]
    end
  end

  def session_or_id_param
    if params[:session_id].present?
      { checkout_session_id: params[:session_id] }
    else
      { id: params[:id] }
    end
  end

  def create_params
    params.permit(:generic_product_id, coffee_attributes: [:quantity, :contributor_name, :comment])
  end
end
