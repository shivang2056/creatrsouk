require 'test_helper'

class StripeProductJobTest < ActiveJob::TestCase
  setup do
    @product = products(:product1)
    @stripe_product = StripeProduct.new(@product)
  end

  test 'create product action calls create_product on service' do
    StripeProduct.expects(:new).with(@product).returns(@stripe_product).once
    @stripe_product.expects(:create_product).once

    perform_enqueued_jobs do
      StripeProductJob.perform_later(@product, action: :create)
    end
  end

  test 'update product action calls update_product on service with price update' do
    price_update = false

    StripeProduct.expects(:new).with(@product).returns(@stripe_product).once
    @stripe_product.expects(:update_product).with(price_update).once

    perform_enqueued_jobs do
      StripeProductJob.perform_later(@product, action: :update, price_update: price_update)
    end
  end
end
