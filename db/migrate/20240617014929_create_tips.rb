class CreateTips < ActiveRecord::Migration[7.1]
  def up
    create_table :tips do |t|
      t.decimal :amount
      t.text :comment
      t.string :giver_name
      t.references :giver, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :user_purchase, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :tips
  end
end
