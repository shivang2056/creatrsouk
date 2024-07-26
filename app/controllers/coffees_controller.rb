class CoffeesController < ApplicationController
  before_action :set_coffee_widget

  def show
    @coffees = @coffee_widget
                .user_purchases
                .includes(:review)
                .reorder(created_at: :desc)
  end

  def update
    if @coffee_widget.update(coffee_params)
      sync_to_stripe

      redirect_to coffee_path, notice: "Coffee Widget updated."
    else
      render :show
    end
  end

  private

  def set_coffee_widget
    @coffee_widget = find_or_initialize_coffee_widget
  end

  def find_or_initialize_coffee_widget
    current_user.coffee_product || build_new_coffee_product
  end

  def build_new_coffee_product
    current_user.build_coffee_product(
      name: "Coffee for #{current_user.full_name}",
      price: 1,
      description: "Coffee for #{current_user.full_name}"
    )
  end

  def coffee_params
    params
      .require(:coffee_product)
      .permit(:active, :price)
  end

  def sync_to_stripe
    StripeProductJob.perform_later(
      @coffee_widget,
      action: determine_stripe_action,
      price_update: @coffee_widget.price_previously_changed?
    )
  end

  def determine_stripe_action
    @coffee_widget.id_previously_changed? ? :create : :update
  end
end
