module ActiveStorageSetCurrent
  extend ActiveSupport::Concern

  included do
    ActiveStorage::Current.url_options = { host: ENV['HOST'] }
  end
end
