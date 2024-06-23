class GenericProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update ]

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
    @product = current_user.generic_products.new
  end

  def edit
    render
  end

  def create
    @product = current_user.generic_products.new(generic_product_params)

    respond_to do |format|
      if @product.save
        create_stripe_product

        format.html { redirect_to edit_generic_product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(generic_product_params)
        format.html { redirect_to edit_generic_product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_products
    @products = current_user
                  .generic_products
                  .includes(:financial)
                  .with_name(params[:query])
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def generic_product_params
      params.require(:generic_product).permit(:name, :description, :price, :user_id, :image, :active)
    end

    def create_stripe_product
      StripeProductJob.perform_later(@product)
    end
end
