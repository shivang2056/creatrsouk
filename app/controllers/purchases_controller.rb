class PurchasesController < ApplicationController
  before_action :authenticate_user!
  def user_purchases
    @bought_products = Product.limit(5)
  end
end
