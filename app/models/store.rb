class Store < ApplicationRecord
  include Rails.application.routes.url_helpers
  DEFAULT_BACKGROUND_COLOR = "#f3f4f6"
  DEFAULT_HIGHTLIGHT_COLOR = "#d4d4d4"

  belongs_to :user
  has_many :generic_products, through: :user
  has_one :coffee_product, through: :user

  delegate :coffee_widget_enabled?, to: :user

  def self.find_by_request(request)
    request.subdomain.present? && find_by(subdomain: request.subdomain)
  end

  def store_url
    return nil unless subdomain.present?

    options = { subdomain: subdomain }
    options.merge!(default_url_options)

    store_root_url(options)
  end

  private

  def default_url_options
    if Rails.env.development? || Rails.env.test?
      { host: 'lvh.me', port: 3000 }
    else
      { host: ENV['HOST'] }
    end
  end
end
