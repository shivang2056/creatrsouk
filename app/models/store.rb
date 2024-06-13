class Store < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  has_many :products, through: :user

  def self.find_by_request(request)
    where(subdomain: request.subdomain).first
  end

  def store_url
    if Rails.env.development?
      store_root_url(subdomain: subdomain, host: 'lvh.me', port: 3000)
    end
  end
end
