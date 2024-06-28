class UserPurchase < ApplicationRecord
  belongs_to :user
  belongs_to :product

  has_one :review

  scope :generic_purchases, -> { joins(:product).where(product: {type: 'GenericProduct'}) }
  scope :coffee_purchases, -> { joins(:product).where(product: {type: 'CoffeeProduct'}) }
end
