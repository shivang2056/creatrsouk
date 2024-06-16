class RatingDecorator
  attr_reader :rating, :rating_count, :fill_stars_count, :transparent_stars_count,
              :partial_star_fill_percent, :partial_star_transparent_percent

  def initialize(product)
    @product = product

    process_ratings if @product.reviews.present?
  end

  def self.decorate(product)
    self.new(product)
  end

  private

  def process_ratings
    @rating = @product.average_rating
    @rating_count = @product.reviews_count
    @fill_stars_count = @rating.to_i
    @transparent_stars_count = (5 - @rating).to_i
    @partial_star_fill_percent = ((@rating - @rating.to_i) * 100).to_f
    @partial_star_transparent_percent = 100 - @partial_star_fill_percent
  end
end
