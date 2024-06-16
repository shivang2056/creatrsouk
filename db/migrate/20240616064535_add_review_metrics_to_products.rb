class AddReviewMetricsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :average_rating, :float
    add_column :products, :reviews_count, :integer
  end
end
