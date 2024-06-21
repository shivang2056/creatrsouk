module ApplicationHelper

  def created_products_tab_color
    current_page?(my_products_products_path) ? "bg-white shadow" : "hover:bg-gray-300"
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
    current_page?(edit_product_path(@product)) ? "bg-white shadow" : "hover:bg-gray-300"
  end

  def product_attachments_tab_color
    current_page?(product_attachments_path(@product)) ? "bg-white shadow" : "hover:bg-gray-300"
  end

  def product_created_by_current_user?
    @product.user_id == current_user.id
  end

  def product_bought_by_current_user?
    current_user.purchases.where(product: @product).any?
  end
end
