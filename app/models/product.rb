class Product < ApplicationRecord
  belongs_to :user

  has_one :financial, class_name: "ProductFinancial"
  has_one_attached :image
  has_many :user_purchases
  has_many :attachments
  has_many :reviews, through: :user_purchases

  validates :name, :price, :description, presence: true
  validates :price, numericality: { greater_than: 0 }

  scope :with_name, ->(name) { where("name ilike ?", "%#{name}%") if name.present? }
  scope :active, -> { where(active: true) }
end
