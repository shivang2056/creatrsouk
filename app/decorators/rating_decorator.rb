class RatingDecorator
  attr_reader :product

  def initialize(product)
    @product = product
  end

  def self.decorate(product)
    new(product)
  end

  def rating
    @_rating ||= product.average_rating
  end

  def rating_count
    product.reviews_count
  end

  def fill_stars_count
    rating.to_i
  end

  def transparent_stars_count
    (5 - rating).to_i
  end

  def partial_star_fill_percent
    @_percent ||= ((rating - rating.to_i) * 100).to_f
  end

  def partial_star_transparent_percent
    100 - partial_star_fill_percent
  end
end
