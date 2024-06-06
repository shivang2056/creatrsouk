class CreateAttachments < ActiveRecord::Migration[7.1]
  def change
    create_table :attachments do |t|
      t.string :name
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
