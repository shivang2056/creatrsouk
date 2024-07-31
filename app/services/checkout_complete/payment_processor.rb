module CheckoutComplete
  class PaymentProcessor
    def initialize(session)
      @session = session
      @balance_transaction = session.payment_intent.latest_charge.balance_transaction
    end

    def process
      return unless paid?

      if two_line_items?
        process_two_line_items
      else
        process_single_line_item
      end
    end

    private

    def paid?
      @session.payment_status == 'paid'
    end

    def two_line_items?
      line_items_data.count == 2
    end

    def process_two_line_items
      net_amounts = compute_net_amount_for_each_line_item

      2.times { |index| process_session_line_item(index, net_amounts[index]) }
    end

    def process_single_line_item
      process_session_line_item(0, @balance_transaction.net)
    end

    def process_session_line_item(index, net_amount)
      product = Product.find_by(stripe_id: line_items_data[index].price.product.id)
      purchase = FinancialManager.new(product, @session, line_items_data[index].quantity, net_amount).process

      ReviewManager.new(@session.metadata, purchase, product.is_a?(CoffeeProduct)).create_coffee_review
    end

    def compute_net_amount_for_each_line_item
      net_amount_for_item1 = (line_items_data[0].amount_total * (1 - stripe_fee_proportion)).to_i
      total_net = @balance_transaction.net

      [net_amount_for_item1, (total_net - net_amount_for_item1)]
    end

    def stripe_fee_proportion
      @balance_transaction.fee.to_f / @balance_transaction.amount.to_f
    end

    def line_items_data
      @session.line_items.data
    end
  end
end
