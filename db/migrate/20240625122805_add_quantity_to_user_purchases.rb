class AddQuantityToUserPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :user_purchases, :quantity, :integer
  end
end
