module Stores
  class GenericProductsController < BaseController
    def index
      @products = @store.generic_products
                        .includes(:user, :reviews, image_attachment: :blob)
                        .active
    end

    def show
      @product = @store.generic_products.find(params[:id])
      @rating_decorator = RatingDecorator.decorate(@product)
    end
  end
end
