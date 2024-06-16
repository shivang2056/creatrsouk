class Review < ApplicationRecord
  after_commit :update_product_review_metrics

  belongs_to :user_purchase

  validate :rating_or_comment

  private

  def update_product_review_metrics
    ProductReviewJob.perform_later(self)
  end

  def rating_or_comment
    errors.add(:base, "Either rating or comment must be present") if rating.blank? && comment.blank?
  end
end
