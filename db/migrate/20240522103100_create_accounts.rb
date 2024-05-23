class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :stripe_id
      t.boolean :details_submitted, default: false
      t.boolean :payouts_enabled, default: false
      t.boolean :charges_enabled, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
