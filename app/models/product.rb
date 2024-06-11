class Product < ApplicationRecord
  belongs_to :user

  has_one :financial, class_name: "ProductFinancial"
  has_one_attached :image
  has_many :attachments

  scope :with_name, ->(name) { where("name ilike '%#{name}%'") if name.present? }
  scope :active, -> { where(active: true) }

  validates :name, :description, :price, presence: true
end
