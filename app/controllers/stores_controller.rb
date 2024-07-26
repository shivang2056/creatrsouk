class StoresController < ApplicationController
  before_action :set_store

  def show
    render
  end

  def update
    if @store.update(store_params)
      redirect_to store_path, notice: "Store details updated."
    else
      flash.now[:error] = error_messages(@store)

      render :show
    end
  end

  private

  def store_params
    params
      .require(:store)
      .permit(:subdomain, :background_color, :highlight_color)
  end

  def set_store
    @store = current_user.store
  end
end
