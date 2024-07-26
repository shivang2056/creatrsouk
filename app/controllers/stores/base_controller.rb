module Stores
  class BaseController < ApplicationController
    layout 'stores'

    skip_before_action :authenticate_user!
    before_action :set_current_store

    def set_current_store
      @store ||= Store.find_by_request(request)
    end
  end
end
