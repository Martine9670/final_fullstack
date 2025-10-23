Rails.application.routes.draw do
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  # Routes Appointments
  get "appointments/index"
  get "appointments/show"
  get "appointments/new"
  get "appointments/edit"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Page d’accueil
  root "home#index"

  # Authentification
  devise_for :users

  # Webhook Stripe
  post '/stripe/webhook', to: 'stripe_webhooks#receive'

  # Ressources principales
  resources :comments
  resources :appointments
  resource :user, only: [:edit, :update]

  # Paiements Stripe
  resources :payments, only: [:new, :create] do
    collection do
      get :success
      get :cancel
    end
  end
end
