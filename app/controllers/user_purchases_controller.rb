class UserPurchasesController < ApplicationController
  before_action :authenticate_user!
  def index
    @bought_products = Product.limit(5)
  end
end
