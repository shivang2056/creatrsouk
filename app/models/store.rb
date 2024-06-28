class Store < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  has_many :generic_products, through: :user
  has_one :coffee_product, through: :user

  delegate :coffee_widget_enabled?, to: :user

  def self.find_by_request(request)
    where(subdomain: request.subdomain).first
  end

  def store_url
    # TODO: Need to add host for non development env.
    if Rails.env.development?
      store_root_url(subdomain: subdomain, host: 'lvh.me', port: 3000)
    end
  end
end
