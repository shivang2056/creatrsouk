class AddCheckoutSessionIdToUserPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :user_purchases, :checkout_session_id, :string
  end
end
