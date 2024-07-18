class GenericProduct < Product
  validates :description, :image, presence: true
end
