class AddStripeDetailsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :stripe_id, :string
    add_column :products, :stripe_price_id, :string
    add_column :products, :data, :json
  end
end
