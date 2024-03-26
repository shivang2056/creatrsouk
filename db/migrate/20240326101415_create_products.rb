class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.boolean :active, default: false
      t.references :user, null: false
      t.string :image

      t.timestamps
    end
  end
end
