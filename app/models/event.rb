class Event < ApplicationRecord
  enum :status, { pending: 0, processing: 1, processed: 2, failed: 3 }
end
