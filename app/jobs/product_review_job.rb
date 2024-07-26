class ProductReviewJob < ApplicationJob
  queue_as :default

  def perform(review)
    product = fetch_product_from_review(review)

    product.update!(
      average_rating: calculate_average_rating(product),
      reviews_count: calculate_reviews_count(product)
    )
  end

  private

  def fetch_product_from_review(review)
    review.user_purchase.product
  end

  def calculate_average_rating(product)
    product.reviews.average(:rating).to_f.round(2)
  end

  def calculate_reviews_count(product)
    product.reviews.count
  end
end
