class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products
  has_many :purchases, class_name: "UserPurchase"
  has_many :reviews, through: :purchases
  has_many :given_tips, class_name: 'Tip', foreign_key: 'giver_id'
  has_many :received_tips, class_name: 'Tip', foreign_key: 'recipient_id'
  has_one :account
  has_one :store

  accepts_nested_attributes_for :store

  def full_name
    [firstname, lastname].reject(&:blank?).join(' ').titleize
  end
end
