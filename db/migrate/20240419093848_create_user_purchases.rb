class CreateUserPurchases < ActiveRecord::Migration[7.1]
  def change
    create_table :user_purchases do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :price

      t.timestamps
    end
  end
end
