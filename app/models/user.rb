class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :generic_products
  has_one :coffee_product
  has_many :user_purchases
  has_many :purchases, -> { generic }, class_name: 'UserPurchase'
  has_many :given_coffees, -> { coffee }, class_name: 'UserPurchase'
  has_many :reviews, through: :purchases
  has_one :account
  has_one :store

  accepts_nested_attributes_for :store

  def full_name
    "#{firstname} #{lastname}".strip.titleize
  end

  def update_name!(name)
    return if name.blank?
    splits = name.split(' ')

    self.update!(firstname: splits.first, lastname: splits.drop(1).join(' '))
  end

  def coffee_widget_enabled?
    coffee_product&.active?
  end
end
