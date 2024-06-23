class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :generic_products
  has_one :coffee_product
  has_many :purchases, -> { joins(:product).where(products: { type: 'GenericProduct' }) }, class_name: 'UserPurchase'
  has_many :given_coffees, -> { joins(:product).where(products: { type: 'CoffeeProduct' }) }, class_name: 'UserPurchase'
  has_many :reviews, through: :purchases
  has_one :account
  has_one :store

  accepts_nested_attributes_for :store

  def full_name
    [firstname, lastname].reject(&:blank?).join(' ').titleize
  end
end
