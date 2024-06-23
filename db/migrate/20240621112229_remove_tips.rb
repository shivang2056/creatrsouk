class RemoveTips < ActiveRecord::Migration[7.1]
  def change
    drop_table :tips
  end
end
