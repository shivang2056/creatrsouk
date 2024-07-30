require 'test_helper'

class ProductReviewsDecoratorTest < ActiveSupport::TestCase

  setup do
    @user = users(:user1)
    @user2 = users(:user2)
    @user_purchase = user_purchases(:purchase1)
    @review = @user_purchase.review
    @product = @user_purchase.product

    @decorator = ProductReviewsDecorator.decorate(@product)
  end

  test "should return processed reviews" do
    reviews = @decorator.reviews

    assert_not_nil reviews
    assert_equal 1, reviews.size
    assert_equal 3, reviews.first.rating
    assert_equal "TestComment", reviews.first.comment
    assert_equal @user2.full_name, reviews.first.reviewer_name
  end

  test "should handle anonymous user" do
    anonymous_user = users(:user3)
    anonymous_user.update!(firstname: nil, lastname: nil)

    anonymous_purchase = UserPurchase.create!(product: @product, user: anonymous_user, review: @review)

    decorator = ProductReviewsDecorator.decorate(@product)
    reviews = decorator.reviews
    assert_equal "Anonymous", reviews.first.reviewer_name
  end
end
