class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products
  has_many :purchases, class_name: "UserPurchase"
  has_one :account

  def full_name
    [firstname, lastname].reject(&:blank?).join(' ').titleize
  end
end
