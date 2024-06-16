class CreateReviews < ActiveRecord::Migration[7.1]
  def up
    create_table :reviews do |t|
      t.integer :rating
      t.text :comment
      t.references :user_purchase, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :reviews
  end
end
