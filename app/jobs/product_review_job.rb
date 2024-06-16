class ProductReviewJob < ApplicationJob
  queue_as :default

  def perform(review)
    product = review.user_purchase.product

    product.update!(
      average_rating: product.reviews.average(:rating).to_f.round(2),
      reviews_count: product.reviews.count
    )
  end
end
