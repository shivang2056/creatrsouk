class Product < ApplicationRecord
  belongs_to :user

  has_one :financial, class_name: "ProductFinancial"

  scope :with_name, ->(name) { where("name ilike '%#{name}%'") if name.present? }
  scope :active, -> { where(active: true) }

  validates :name, :description, :price, presence: true

  has_one_attached :image do |image|
    image.variant :card, resize_to_limit: [350, 240]
  end

  has_many :attachments
end
