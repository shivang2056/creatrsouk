class CreateStores < ActiveRecord::Migration[7.1]
  def change
    create_table :stores do |t|
      t.string :subdomain
      t.string :background_color
      t.string :highlight_color
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
