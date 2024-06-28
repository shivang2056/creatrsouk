class RemoveBuyCoffeeWidgetFromStores < ActiveRecord::Migration[7.1]
  def change
    remove_column :stores, :buy_coffee_widget
  end
end
