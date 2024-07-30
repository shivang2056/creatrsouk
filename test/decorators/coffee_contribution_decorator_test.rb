require 'test_helper'

class CoffeeContributionDecoratorTest < ActiveSupport::TestCase
  setup do
    @coffee = products(:coffee_product1)
    @user = @coffee.user
    @user2 = users(:user2)
    @user3 = users(:user3)
    @decorator = CoffeeContributionDecorator.decorate(@coffee)
  end

  test 'should correctly count contributions' do
    assert_equal 0, @decorator.contributions_count

    @coffee.create_financial(user: @user, sales: 5)
    @decorator = CoffeeContributionDecorator.decorate(@coffee)

    assert_equal 5, @decorator.contributions_count
  end

  test 'should correctly calculate total contributions amount' do
    assert_equal '$0.00', @decorator.total_contributions_amount

    @coffee.create_financial(user: @user, revenue: 100)
    @decorator = CoffeeContributionDecorator.decorate(@coffee)

    assert_equal '$100.00', @decorator.total_contributions_amount
  end

  test 'should handle contributions list' do
    @coffee.user_purchases.destroy_all
    purchase_one = UserPurchase.create(user: @user2, quantity: 2, price: 5, product: @coffee, review: Review.new(comment: 'Great!'))
    purchase_two = UserPurchase.create(user: @user3, quantity: 1, price: 3, product: @coffee, review: nil)
    @decorator = CoffeeContributionDecorator.decorate(@coffee)
    expected = [
      {
        contributor_name: @user3.full_name,
        quantity: 'a coffee',
        price_per_coffee: '$3.00',
        comment: nil
      },
      {
        contributor_name: @user2.full_name,
        quantity: '2 coffees',
        price_per_coffee: '$5.00',
        comment: 'Great!'
      }
    ]

    assert_equal expected, @decorator.contributions
  end

  test 'should handle nil financial' do
    assert_nil @coffee.financial
    assert_equal 0, @decorator.contributions_count
    assert_equal '$0.00', @decorator.total_contributions_amount
  end
end
