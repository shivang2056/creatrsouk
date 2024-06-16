class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update ]

  def index
    @products = Product
                  .includes(:user, :reviews, image_attachment: :blob)
                  .active
                  .with_name(params[:query])
  end

  def show
    @rating_decorator = RatingDecorator.decorate(@product)
  end

  def new
    @product = Product.new
  end

  def edit
    render
  end

  def create
    @product = Product.new(product_params.merge(user: current_user))

    respond_to do |format|
      if @product.save
        create_stripe_product

        format.html { redirect_to edit_product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to edit_product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_products
    @products = current_user
                  .products
                  .includes(:financial)
                  .with_name(params[:query])
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, :user_id, :image, :active)
    end

    def create_stripe_product
      StripeProductJob.perform_later(@product)
    end
end
