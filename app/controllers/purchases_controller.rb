class PurchasesController < ApplicationController
  def user_purchases
    @bought_products = Product.limit(5)
  end
end
