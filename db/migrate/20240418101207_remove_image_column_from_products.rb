class RemoveImageColumnFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :image
  end
end
