class UserPurchase < ApplicationRecord
  belongs_to :user
  belongs_to :product

  has_one :review
end
