module ApplicationHelper

  def created_products_tab_color
    current_page?(my_products_products_path) ? "bg-white shadow" : "hover:bg-gray-300"
  end

  def bought_products_tab_color
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

  def product_created_by_current_user?
    current_user.products.any?(@product)
  end

  def product_bought_by_current_user?
    current_user.purchases.where(product: @product).any?
  end
end
