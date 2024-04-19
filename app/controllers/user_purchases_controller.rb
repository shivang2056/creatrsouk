class UserPurchasesController < ApplicationController
  before_action :authenticate_user!
  def index
    @bought_products = current_user.purchases.map(&:product)
  end

  def create
    @product = Product.find(params[:product_id])

    if current_user.purchases.create(product: @product)
      redirect_to my_purchases_path
    else
      render 'products/show'
    end
  end
end
