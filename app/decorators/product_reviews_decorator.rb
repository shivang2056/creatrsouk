class ProductReviewsDecorator
  attr_reader :reviews

  def initialize(product)
    @product = product

    process_reviews
  end

  def self.decorate(product)
    self.new(product)
  end

  private

  def process_reviews
    @reviews = @product
                .user_purchases
                .includes(:review, :user)
                .joins(:review)
                .map do |purchase|
      OpenStruct.new({
        rating: purchase.review.rating,
        comment: purchase.review.comment,
        reviewer_name: purchase.user.full_name.presence || "Anonymous"
      })
    end
  end
end
