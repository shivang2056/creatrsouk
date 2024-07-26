module LayoutHelper

  def layout_by_resource
    devise_action? ? "devise" : "application"
  end
end