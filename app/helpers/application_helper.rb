module ApplicationHelper

  def my_products_link_text_color
    action_name == "user_products" ? "text-blue-600" : "text-gray-500"
  end

  def my_purchases_link_text_color
    action_name == "index" ? "text-blue-600" : "text-gray-500"
  end

  def product_created_by_current_user?
    current_user.products.any?(@product)
  end

  def product_bought_by_current_user?
    current_user.purchases.where(product: @product).any?
  end
end
