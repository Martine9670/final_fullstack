Rails.application.routes.draw do
get "/cgu", to: "pages#cgu"
  namespace :admin do
    # Dashboard (accessible via /admin/dashboard)
    get 'dashboard', to: 'dashboard#index'
    patch 'users/:id/toggle_admin', to: 'dashboard#toggle_admin', as: 'toggle_admin_user'
  end

  # ✅ No more manual GET routes for appointments — handled automatically below

  # Health check (GET allowed)
  get "up" => "rails/health#show", as: :rails_health_check

  # Home page
  root "home#index"

  # Authentication
  devise_for :users

  # Stripe webhook (only POST allowed)
  post '/stripe/webhook', to: 'stripe_webhooks#receive'

  # Main resources
  resources :comments

  resources :appointments do
    member do
      patch :update_status
    end
  end

  resource :user, only: [:edit, :update]

  # Stripe (GET allowed here for redirect success/cancel)
  resources :payments, only: [:new, :create] do
    collection do
      get :success
      get :cancel
    end
  end

  # Reviews + likes + nested comments
  resources :reviews, only: [:index, :show, :new, :create, :destroy] do
    # Route to like/unlike a review
    post "like", to: "likes#toggle"

    # Routes for comments related to a review
    resources :comments, only: [:create, :destroy]
  end
end
