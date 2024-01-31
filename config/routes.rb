Rails.application.routes.draw do
  root 'static_pages#home'

  get "sign_up", to: "users#new"
  post "sign_up", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "login", to: "sessions#destroy"

  patch "/account", to: "users#update"
  get "/account", to: "users#edit"
  delete "/account", to: "users#destroy"

  get "/profile", to: "profiles#show"

  resources :confirmations, only: [:new, :create, :edit], param: :confirmation_token

  resource :password_resets, only: [:new, :create, :edit, :update]

  resource :password, only: [:edit, :update]

  resources :active_sessions, only: [:destroy] do
    collection do
      delete "destoy_all"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
