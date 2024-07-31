require 'test_helper'

module CheckoutComplete
  class PaymentProcessorTest < ActiveSupport::TestCase
    setup do
      @purchase = user_purchases(:purchase1)
      @coffee_purchase = user_purchases(:coffee_purchase1)
      @product = products(:product1)
      @coffee_product = products(:coffee_product1)
      @product.update_column(:stripe_id, 'product_stripe_id')
      @coffee_product.update(stripe_id: 'coffee_product_stripe_id')
    end

    test "should not process if payment status is not paid in session with 2 line items" do
      session = session_with_two_line_items(paid: false)
      processor = CheckoutComplete::PaymentProcessor.new(session)

      processor.expects(:process_single_line_item).never
      processor.expects(:process_two_line_items).never

      processor.process
    end

    test "should not process if payment status is not paid in session with 1 line item" do
      session = session_with_single_line_item(paid: false)
      processor = CheckoutComplete::PaymentProcessor.new(session)

      processor.expects(:process_single_line_item).never
      processor.expects(:process_two_line_items).never

      processor.process
    end

    test "should process single line item" do
      session = session_with_single_line_item
      financial_manager = FinancialManager.new(@product, session, 1, 123)
      review_manager = ReviewManager.new(session.metadata, @purchase, false)

      FinancialManager.expects(:new).with(@product, session, 1, 123).returns(financial_manager).once
      financial_manager.expects(:process).returns(@purchase).once
      ReviewManager.expects(:new).with({}, @purchase, false).returns(review_manager).once
      review_manager.expects(:create_coffee_review).once

      processor = CheckoutComplete::PaymentProcessor.new(session)
      processor.process
    end

    test "should process two line items" do
      session = session_with_two_line_items

      financial_manager1 = FinancialManager.new(@product, session, 1, 115)
      review_manager1 = ReviewManager.new(session.metadata, @purchase, false)

      financial_manager2 = FinancialManager.new(@coffee_product, session, 2, 920)
      review_manager2 = ReviewManager.new(session.metadata, @coffee_purchase, true)

      FinancialManager.expects(:new).with(@product, session, 1, 115).returns(financial_manager1)
      financial_manager1.expects(:process).returns(@purchase)
      ReviewManager.expects(:new).with({}, @purchase, false).returns(review_manager1)
      review_manager1.expects(:create_coffee_review)

      FinancialManager.expects(:new).with(@coffee_product, session, 2, 920).returns(financial_manager2)
      financial_manager2.expects(:process).returns(@coffee_purchase)
      ReviewManager.expects(:new).with({}, @coffee_purchase, true).returns(review_manager2)
      review_manager2.expects(:create_coffee_review)

      processor = CheckoutComplete::PaymentProcessor.new(session)
      processor.process
    end

    private

    def session_with_single_line_item(paid: true)
      Stripe::Checkout::Session.construct_from(
        id: 'session_id',
        customer_details: { email: "test@sample.com" },
        payment_status: (paid ? 'paid' : 'unpaid'),
        metadata: {},
        line_items: {
          data: [
            { amount_total: 123, quantity: 1, price: { product: { id: 'product_stripe_id' } }}
          ]
        },
        payment_intent: {
          latest_charge: {
            receipt_url: "http://test.com/receipt_url",
            balance_transaction: {
              net: 123,
              fee: 7,
              amount: 130
            }
          }
        }
      )
    end

    def session_with_two_line_items(paid: true)
      Stripe::Checkout::Session.construct_from(
        id: 'session_id',
        customer_details: { email: "test@sample.com" },
        payment_status: (paid ? 'paid' : 'unpaid'),
        metadata: {},
        line_items: {
          data: [
            { amount_total: 123, quantity: 1, price: { product: { id: 'product_stripe_id' } }},
            { amount_total: 456, quantity: 2, price: { product: { id: 'coffee_product_stripe_id' } }}
          ]
        },
        payment_intent: {
          latest_charge: {
            receipt_url: "http://test.com/receipt_url",
            balance_transaction: {
              net: 1035,
              fee: 65,
              amount: 1100
            }
          }
        }
      )
    end
  end
end
