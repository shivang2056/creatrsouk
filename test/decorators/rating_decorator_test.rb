require 'test_helper'

class RatingDecoratorTest < ActiveSupport::TestCase
  setup do
    @product = products(:product1)
    @product.image.attach(file_fixture('image.jpeg'))
    @product.update!(average_rating: 3.3, reviews_count: 150)
    @decorator = RatingDecorator.decorate(@product)
  end

  test "should return correct average rating" do
    assert_equal 3.3, @decorator.rating
  end

  test "should return correct reviews count" do
    assert_equal 150, @decorator.rating_count
  end

  test "should calculate correct full stars count" do
    assert_equal 3, @decorator.fill_stars_count
  end

  test "should calculate correct transparent stars count" do
    assert_equal 1, @decorator.transparent_stars_count
  end

  test "should calculate correct partial star fill percentage" do
    assert_in_delta 30.0, @decorator.partial_star_fill_percent, 0.01
  end

  test "should calculate correct partial star transparent percentage" do
    assert_in_delta 70.0, @decorator.partial_star_transparent_percent, 0.01
  end
end
