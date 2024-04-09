Rails.application.routes.draw do
  resources :products
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "dashboard" => "home#index", as: :dashboard
  get "my_products" => "home#my_products", as: :my_products
  get "discover" => "products#index", as: :discover
  get "my_profile" => "home#my_profile", as: :my_profile


  root "home#index"
end
