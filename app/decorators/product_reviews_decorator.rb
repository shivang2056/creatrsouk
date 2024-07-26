class ProductReviewsDecorator
  attr_reader :product

  def initialize(product)
    @product = product
  end

  def self.decorate(product)
    new(product)
  end

  def reviews
    @reviews ||= process_reviews
  end

  private

  def process_reviews
    user_purchases = product
                      .user_purchases
                      .includes(:review, :user)
                      .joins(:review)

    user_purchases.map do |purchase|
      review_struct(purchase)
    end
  end

  def review_struct(purchase)
    OpenStruct.new({
      rating: purchase.review.rating,
      comment: purchase.review.comment,
      reviewer_name: purchase.user.full_name.presence || "Anonymous"
    })
  end
end
