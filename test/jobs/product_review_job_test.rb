require 'test_helper'

class ProductReviewJobTest < ActiveJob::TestCase
  setup do
    @product = products(:product1)
    @product.image.attach(file_fixture('image.jpeg'))
    @purchase2 = user_purchases(:purchase2)
  end

  test "perform updates product with correct average rating and reviews count" do
    @product.update(average_rating: 3, reviews_count: 1)
    review = @purchase2.create_review!(rating: 4)

    ProductReviewJob.perform_now(review)

    @product.reload

    assert_equal 3.5, @product.average_rating
    assert_equal 2, @product.reviews_count
  end
end
