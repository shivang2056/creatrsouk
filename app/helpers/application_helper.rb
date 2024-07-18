module ApplicationHelper

  def created_products_tab_color
    current_page?(my_products_generic_products_path) ? "bg-white shadow" : "hover:bg-gray-300"
  end

  def purchases_tab_color
    current_page?(user_purchases_path) ? "bg-white shadow" : "hover:bg-gray-300"
  end

  def account_settings_tab_color
    current_page?(account_path) ? "bg-white shadow" : "hover:bg-gray-300"
  end

  def store_settings_tab_color
    current_page?(store_path) ? "bg-white shadow" : "hover:bg-gray-300"
  end

  def profile_settings_tab_color
    current_page?(my_profile_path) ? "bg-white shadow" : "hover:bg-gray-300"
  end

  def edit_product_tab_color
    current_page?(edit_generic_product_path(@product)) ? "bg-white shadow" : "hover:bg-gray-300"
  end

  def product_attachments_tab_color
    current_page?(generic_product_attachments_path(@product)) ? "bg-white shadow" : "hover:bg-gray-300"
  end

  def coffee_widget_tab_color
    current_page?(coffee_path) ? "bg-white shadow" : "hover:bg-gray-300"
  end

  def coffee_widget_tab_color
    current_page?(coffee_path) ? "bg-white shadow" : "hover:bg-gray-300"
  end

  def product_created_by_current_user?
    @product.user_id == current_user.id
  end
end
