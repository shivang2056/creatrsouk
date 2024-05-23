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

  get "my_products" => "products#user_products", as: :my_products
  get "discover" => "products#index", as: :discover

  get "my_purchases" => "user_purchases#index", as: :my_purchases
  post 'buy_now' => 'user_purchases#create', as: :buy_now

  devise_scope :user do
    get "my_profile" => "devise/registrations#edit", as: :my_profile
  end

  post '/webhooks/:source', to: 'webhooks#create'

  root "home#index"
end
