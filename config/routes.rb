Rails.application.routes.draw do
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    patch 'users/:id/toggle_admin', to: 'dashboard#toggle_admin', as: 'toggle_admin_user'
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

  # 🌟 Ajout des avis (reviews) + likes + commentaires imbriqués
  resources :reviews, only: [:index, :show, :new, :create, :destroy] do
    # Route pour liker/unliker un avis
    post "like", to: "likes#toggle"

    # Routes pour les commentaires liés à un avis
    resources :comments, only: [:create]
  end
end

