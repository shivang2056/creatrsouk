class AddBuyCoffeeWidgetToStore < ActiveRecord::Migration[7.1]
  def change
    add_column :stores, :buy_coffee_widget, :boolean, default: false
  end
end
