module DeviseHelper

  def devise_action?
    devise_controller? && resource_name == :user && !(controller_name == "registrations" && action_name == "edit")
  end
end