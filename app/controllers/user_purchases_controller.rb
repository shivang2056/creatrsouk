class UserPurchasesController < ApplicationController

  def index
    @bought_products = current_user.purchases.map(&:product)
  end

  def create
    @product = Product.find(params[:product_id])

    # TODO: Refactor to wrap it into Transaction
    if current_user.purchases.create(product: @product, price: @product.price)
      financial = @product.financial || @product.initialize_financial(user: product.user)
      financial.revenue += @product.price
      financial.sales += 1
      financial.save!

      redirect_to my_purchases_path
    else
      render 'products/show'
    end
  end
end
