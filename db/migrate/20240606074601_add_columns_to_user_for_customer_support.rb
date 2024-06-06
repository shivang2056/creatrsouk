class AddColumnsToUserForCustomerSupport < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :customer, :boolean, default: false
  end
end

