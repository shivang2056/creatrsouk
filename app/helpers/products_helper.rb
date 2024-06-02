module ProductsHelper

  def back_button_path
    request.referrer || ( product_created_by_current_user? ? my_products_products_path : discover_products_path )
  end
end
