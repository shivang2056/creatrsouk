class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  layout :layout_by_resource

  def layout_by_resource
    if devise_action?
      "devise"
    else
      "application"
    end
  end

  private

  def turbo_stream_update(element, partial, locals = {})
    turbo_stream.update(element,
      partial: partial,
      locals: locals
    )
  end

  def devise_action?
    devise_controller? && resource_name == :user && !(controller_name == "registrations" && action_name == "edit")
  end
end
