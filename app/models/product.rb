class Product < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  scope :with_name, ->(name) { where("name ilike '%#{name}%'") if name.present? }
end
