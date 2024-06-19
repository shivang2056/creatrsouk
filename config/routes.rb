require 'constraints/subdomain_constraint'

Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  constraints SubdomainConstraint do
    scope module: :stores do
      resources :products, only: [:index, :show], as: :store_products
      root to: 'products#index', as: 'store_root'
      resource :checkout, only: [:show, :create], as: :store_checkout do
        get :new_coffee, on: :collection
      end

      resources :user_purchases, only: [] do
        resources :reviews, only: [:create, :edit, :update], as: :store_review
      end
    end
  end

  resources :products do
    get "my_products", to: "products#user_products", on: :collection
    get "discover", to: "products#index", on: :collection

    resources :attachments, only: [:index, :create, :destroy]
  end

  resources :user_purchases, only: [:index, :create, :show] do
    resources :reviews, only: [:create, :edit, :update]
  end
  resource :account, only: [:show, :create]
  resource :store, only: [:show, :update]

  devise_scope :user do
    get "my_profile" => "devise/registrations#edit", as: :my_profile
  end

  post '/webhooks/:source', to: 'webhooks#create'

  root "products#index"
end
