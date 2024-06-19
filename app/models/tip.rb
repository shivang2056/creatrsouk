class Tip < ApplicationRecord
  belongs_to :giver, class_name: 'User', foreign_key: 'giver_id', optional: true
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :user_purchase, optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
end
