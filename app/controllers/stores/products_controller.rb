module Stores
  class ProductsController < BaseController
    def index
      @products = @store.products
                        .includes(:user, image_attachment: :blob)
                        .active
                        .with_name(params[:query])
    end

    def show
      @product = @store.products.find(params[:id])
    end
  end
end
