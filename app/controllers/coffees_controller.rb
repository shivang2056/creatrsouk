class CoffeesController < ApplicationController
  before_action :set_coffee_widget

  def show
    render
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
    @coffee_widget = current_user.coffee_product ||
                      current_user.build_coffee_product(
                        name: 'Coffee Widget',
                        price: 1,
                        description: 'Coffee Widget'
                      )
  end

  def coffee_params
    params.require(:coffee_product).permit(:active, :price)
  end

  def sync_to_stripe
    StripeProductJob.perform_later(
      @coffee_widget,
      options: {
        create: @coffee_widget.id_previously_changed?,
        price_update: @coffee_widget.price_previously_changed?
      }
    )
  end
end
