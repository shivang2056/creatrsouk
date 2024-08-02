class AddDefaultsToProductsAverageRatingAndReviewsCount < ActiveRecord::Migration[7.1]
  def up
    change_column :products, :average_rating, :float, default: 0.0
    change_column :products, :reviews_count, :integer, default: 0
  end
end
