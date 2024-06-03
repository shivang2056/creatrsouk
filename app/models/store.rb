class Store < ApplicationRecord
  belongs_to :user
  has_many :products, through: :user

  def self.find_by_request(request)
    where(subdomain: request.subdomain).first
  end
end
