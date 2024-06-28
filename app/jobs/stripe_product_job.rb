class StripeProductJob < ApplicationJob
  queue_as :default

  def perform(product, options: {})
    service = StripeProduct.new(product)

    options[:create] ? service.create_product : service.update_product(options[:price_update])
  end
end
