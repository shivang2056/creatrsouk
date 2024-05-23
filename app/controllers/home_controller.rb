class HomeController < ApplicationController

  def index
    render
  end

  def my_products
    @bought_products = Product.all
  end

  def discover
    @products = Product.all
  end

  def my_profile
    render :index
  end
end
