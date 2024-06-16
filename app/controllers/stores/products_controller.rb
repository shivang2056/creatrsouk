module Stores
  class ProductsController < BaseController
    def index
      @products = @store.products
                        .includes(:user, image_attachment: :blob)
                        .active
    end

    def show
      @product = @store.products.find(params[:id])
      @rating_decorator = RatingDecorator.decorate(@product)
    end
  end
end
