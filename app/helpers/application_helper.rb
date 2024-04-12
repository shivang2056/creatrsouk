module ApplicationHelper

  def my_products_link_text_color
    action_name == "user_products" ? "text-blue-600" : "text-gray-500"
  end

  def my_purchases_link_text_color
    action_name == "user_purchases" ? "text-blue-600" : "text-gray-500"
  end
end
