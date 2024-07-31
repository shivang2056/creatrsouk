require 'test_helper'

module CheckoutComplete
  class ReviewManagerTest < ActiveSupport::TestCase
    setup do
      @coffee_data = OpenStruct.new(coffee: "true", comment: "test comment", giver_name: "First Last")
      @user_purchase = user_purchases(:coffee_purchase1)
      @user = @user_purchase.user
    end

    test 'should not create review if not a coffee product' do
      manager = ReviewManager.new(@coffee_data, @user_purchase, false)

      assert_no_difference("Review.count") do
        manager.create_coffee_review
      end
    end

    test 'should create review and update user name if a coffee product' do
      manager = ReviewManager.new(@coffee_data, @user_purchase, true)

      assert_difference("Review.count") do
        manager.create_coffee_review
      end

      assert_equal "test comment", @user_purchase.review.comment
      assert_equal "First Last", @user.reload.full_name
    end

    test 'should not create review if coffee_data coffee is not true' do
      @coffee_data.coffee = "false"
      manager = ReviewManager.new(@coffee_data, @user_purchase, true)

      assert_no_difference("Review.count") do
        manager.create_coffee_review
      end
    end

    test 'should not create review if comment is not present' do
      @coffee_data.comment = nil
      manager = ReviewManager.new(@coffee_data, @user_purchase, true)

      assert_no_difference("Review.count") do
        manager.create_coffee_review
      end
    end
  end
end
