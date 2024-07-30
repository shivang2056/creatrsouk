class CoffeeContributionDecorator
  include ActiveSupport::NumberHelper

  def initialize(coffee)
    @coffee = coffee
    @financial = @coffee.financial
  end

  def self.decorate(coffee)
    new(coffee)
  end

  def contributions_count
    @financial ? @financial.sales : 0
  end

  def total_contributions_amount
    amount = @financial ? @financial.revenue : 0

    number_to_currency(amount)
  end

  def contributions
    coffee_purchases.reorder(created_at: :desc).map do |purchase|
      {
        contributor_name: contributor_name(purchase),
        quantity: quantity(purchase),
        price_per_coffee: price_per_coffee(purchase),
        comment: purchase_comment(purchase)
      }
    end
  end

  private

  def coffee_purchases
    @coffee
      .user_purchases
      .includes(:review)
      .reorder(created_at: :desc)
  end

  def contributor_name(purchase)
    purchase.user.full_name.presence || "Anonymous"
  end

  def quantity(purchase)
    purchase.quantity > 1 ? "#{purchase.quantity} coffees" : "a coffee"
  end

  def price_per_coffee(purchase)
    number_to_currency(purchase.price)
  end

  def purchase_comment(purchase)
    purchase.review.comment if purchase.review.present?
  end
end
