class CoffeeProduct < Product
  validates :user_id, uniqueness: true
end