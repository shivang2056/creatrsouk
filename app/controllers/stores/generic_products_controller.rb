module Stores
  class GenericProductsController < BaseController
    before_action :set_product, only: [:show, :reviews]

    def index
      @products = @store
                    .generic_products
                    .includes(:user, :reviews, image_attachment: :blob)
                    .active
    end

    def show
      @rating_decorator = RatingDecorator.decorate(@product)
    end

    def reviews
      reviews_decorator = ProductReviewsDecorator.decorate(@product)

      render turbo_stream: turbo_stream_update("modal", "generic_products/reviews",
        {
          product: @product,
          reviews: reviews_decorator.reviews
        }
      )
    end

    private

    def set_product
      @product = @store
                  .generic_products
                  .find(params[:id])
    end
  end
end
