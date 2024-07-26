class GenericProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update reviews ]
  before_action :build_product, only: %i[ new create ]

  def index
    @products = GenericProduct
                  .includes(:user, :reviews, image_attachment: :blob)
                  .active
                  .with_name(params[:query])
  end

  def show
    @rating_decorator = RatingDecorator.decorate(@product)
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    if @product.save
      handle_success("Product was successfully created.")
    else
      handle_failure(:new)
    end
  end

  def update
    if @product.update(generic_product_params)
      handle_success("Product was successfully updated.")
    else
      handle_failure(:edit)
    end
  end

  def user_products
    @products = current_user
                  .generic_products
                  .includes(:financial)
                  .with_name(params[:query])
  end

  def reviews
    reviews_decorator = ProductReviewsDecorator.decorate(@product)

    render turbo_stream: turbo_stream_update("modal", "reviews",
      {
        product: @product,
        reviews: reviews_decorator.reviews
      }
    )
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def build_product
    @product = current_user
                .generic_products
                .new(generic_product_params)
  end

  def generic_product_params
    params
      .require(:generic_product)
      .permit(:name, :description, :price, :user_id, :image, :active)
  end

  def handle_success(flash_notice)
    sync_to_stripe

    redirect_to edit_generic_product_url(@product), notice: flash_notice
  end

  def handle_failure(render_action)
    render render_action, status: :unprocessable_entity
  end

  def sync_to_stripe
    StripeProductJob.perform_later(
      @product,
      action: determine_stripe_action,
      price_update: @product.price_previously_changed?
    )
  end

  def determine_stripe_action
    @product.id_previously_changed? ? :create : :update
  end
end
