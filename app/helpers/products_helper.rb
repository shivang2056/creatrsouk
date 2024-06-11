module ProductsHelper

  def product_show_back_button_path
    request.referrer || ( product_created_by_current_user? ? my_products_products_path : discover_products_path )
  end

  def product_already_purchased?
    current_user.purchases.where(product: @product).any?
  end
end
