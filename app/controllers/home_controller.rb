class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    render
  end

  def my_products
    render :index
  end

  def discover
    @products = Product.all
  end

  def my_profile
    render :index
  end
end
