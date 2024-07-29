require 'test_helper'

module Stores
  class ReviewsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      @store = stores(:store1)
      @user = users(:user1)
      @user_purchase1 = user_purchases(:purchase1)
      @user_purchase2 = user_purchases(:purchase2)
      @review = @user_purchase1.review
      Store.stubs(:find_by_request).returns(@store)

      sign_in @user
    end

    test "should create review" do
      assert_difference('Review.count') do
        post user_purchase_store_review_index_url(@user_purchase2), params: { review: { rating: 5, comment: "Test Comment" } }
      end

      assert_response :success
      assert_equal "Review Posted.", flash[:notice]
    end

    test "should not create review with invalid params" do
      assert_no_difference('Review.count') do
        post user_purchase_store_review_index_url(@user_purchase2), params: { review: { rating: nil } }
      end

      assert_response :success
      assert_equal "Either rating or comment must be present", flash[:error]
    end

    test "should get edit" do
      get edit_user_purchase_store_review_url(@user_purchase1, @review)

      assert_response :success
    end

    test "should update review" do
      patch user_purchase_store_review_url(@user_purchase1, @review), params: { review: { comment: "New test comment" } }

      assert_response :success
      assert_equal "Review Updated.", flash[:notice]
      assert_equal "New test comment", @review.reload.comment
    end

    test "should not update review with invalid params" do
      patch user_purchase_store_review_url(@user_purchase1, @review), params: { review: { rating: nil, comment: nil } }

      assert_response :success
      assert_equal "Either rating or comment must be present", flash[:error]
      assert_not_nil @review.reload.comment
      assert_not_nil @review.rating
    end
  end
end
