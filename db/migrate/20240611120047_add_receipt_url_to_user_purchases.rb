class AddReceiptUrlToUserPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :user_purchases, :receipt_url, :string
  end
end
