class StoresController < ApplicationController
  before_action :set_store

  def show
    render
  end

  def update
    if @store.update(store_params)
      sync_to_stripe

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

  def sync_to_stripe
    if @store.background_color_previously_changed? || @store.highlight_color_previously_changed?
      StripeAccountJob.perform_later(@store.user.account, action: :update_branding)
    end
  end

  def set_store
    @store = current_user.store || current_user.build_store(background_color: '#f3f4f6', highlight_color: '#000000')
  end
end
