class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  layout :layout_by_resource

  def layout_by_resource
    if devise_controller? && resource_name == :user && !(controller_name == "registrations" && action_name == "edit")
      "devise"
    else
      "application"
    end
  end
end
