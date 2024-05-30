module ProductsHelper

  def back_button_config
    if product_created_by_current_user?
      label = "Back to My Products"
      path = my_products_path
    else
      label = "Back to Discover"
      path = discover_path
    end

    {
      label: label,
      path: path
    }
  end
end
