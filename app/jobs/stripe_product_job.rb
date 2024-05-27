class StripeProductJob < ApplicationJob
  queue_as :default

  def perform(product)
    service = StripeProduct.new(product)
    service.create_product
  end
end
