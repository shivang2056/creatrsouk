class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  layout :layout_by_resource

  include LayoutHelper
  include TurboStreamsHelper
  include DeviseHelper

  private

  def error_messages(object)
    object
      .errors
      .full_messages
      .to_sentence
  end
end
