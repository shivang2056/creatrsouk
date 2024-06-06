class Attachment < ApplicationRecord
  belongs_to :product

  has_one_attached :file

  validates :name, :file, presence: true
end
