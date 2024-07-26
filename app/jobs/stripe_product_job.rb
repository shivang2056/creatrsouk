class StripeProductJob < ApplicationJob
  queue_as :default

  def perform(product, action: :create, price_update: nil)
    service = StripeProduct.new(product)

    case action
    when :create
      service.create_product
    when :update
      service.update_product(price_update)
    end
  end
end
