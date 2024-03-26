class HomeController < ApplicationController

  def index
    render
  end

  def my_products
    render :index
  end

  def discover
    render :index
  end

  def my_profile
    render :index
  end
end
