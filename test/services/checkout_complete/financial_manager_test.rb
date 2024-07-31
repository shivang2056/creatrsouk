require 'test_helper'

module CheckoutComplete
  class FinancialManagerTest < ActiveSupport::TestCase
    setup do
      @product = products(:product1)
      @session = Stripe::Checkout::Session.construct_from(
        {
          id: 'session_id',
          customer_details: { email: "test@sample.com" },
          payment_intent: {
            latest_charge: {
              receipt_url: 'http://test.com/receipt_url'
            }
          }
        }
      )
      @quantity = 2
      @net_amount = 20000
      @financial_manager = FinancialManager.new(@product, @session, @quantity, @net_amount)
    end

    test "process method calls update_product_financials and update_customer_purchases" do
      @financial_manager.expects(:update_product_financials).once
      @financial_manager.expects(:update_customer_purchases).once
      @financial_manager.process
    end

    test "creates new financial and updates financial details" do
      assert_difference 'ProductFinancial.count', 1 do
        @financial_manager.process
      end

      assert_equal 200.0, @product.financial.revenue
      assert_equal 1, @product.financial.sales
    end

    test "updates existing financial with new financial details" do
      financial = @product.create_financial(user: @product.user, sales: 2, revenue: 232)

      assert_no_difference 'ProductFinancial.count' do
        assert_changes 'financial.revenue', from: 232.0, to: 432.0 do
          assert_changes 'financial.sales', from: 2, to: 3 do
            @financial_manager.process
          end
        end
      end
    end

    test "update_customer_purchases with new customer" do
      assert_difference 'User.count', 1 do
        assert_difference 'UserPurchase.count', 1 do
          @purchase = @financial_manager.process
        end
      end

      assert_equal @product.id, @purchase.product_id
      assert_equal @product.price, @purchase.price
      assert_equal @session.id, @purchase.checkout_session_id
      assert_equal 'http://test.com/receipt_url', @purchase.receipt_url
      assert_equal @quantity, @purchase.quantity
    end

    test "update_customer_purchases with existing customer" do
      User.create(email: 'test@sample.com', customer: true, password: 'password')

      assert_no_difference 'User.count' do
        assert_difference 'UserPurchase.count', 1 do
          @purchase = @financial_manager.send(:update_customer_purchases)
        end
      end

      assert_equal @product.id, @purchase.product_id
      assert_equal @product.price, @purchase.price
      assert_equal @session.id, @purchase.checkout_session_id
      assert_equal 'http://test.com/receipt_url', @purchase.receipt_url
      assert_equal @quantity, @purchase.quantity
    end
  end
end

