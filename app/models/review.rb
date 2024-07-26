class Review < ApplicationRecord
  after_commit :update_product_review_metrics

  belongs_to :user_purchase

  validate :presence_of_rating_or_comment

  private

  def update_product_review_metrics
    ProductReviewJob.perform_later(self)
  end

  def presence_of_rating_or_comment
    if rating.blank? && comment.blank?
      errors.add(:base, "Either rating or comment must be present")
    end
  end
end
