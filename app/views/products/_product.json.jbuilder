json.extract! product, :id, :name, :description, :price, :user_id, :image, :created_at, :updated_at
json.url product_url(product, format: :json)
