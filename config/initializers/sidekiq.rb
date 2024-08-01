# config/initializers/sidekiq.rb

if Rails.env.production?
  redis_config = { url: ENV["REDIS_URL"] }

  Sidekiq.configure_server do |config|
    config.redis = redis_config
  end

  Sidekiq.configure_client do |config|
    config.redis = redis_config
  end
end