class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def update
    super do |resource|
      flash[:notice] = "Profile updated successfully" if resource.errors.empty?
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:firstname, :lastname])
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end