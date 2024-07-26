class UserPurchase < ApplicationRecord
  belongs_to :user
  belongs_to :product

  has_one :review

  scope :generic, -> { joins(:product).where(products: {type: 'GenericProduct'}) }
  scope :coffee, -> { joins(:product).where(products: {type: 'CoffeeProduct'}) }
end
