class CreateProductFinancials < ActiveRecord::Migration[7.1]
  def change
    create_table :product_financials do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :revenue
      t.integer :sales

      t.timestamps
    end
  end
end
