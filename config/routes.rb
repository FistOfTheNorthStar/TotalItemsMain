require "sidekiq/web"

Rails.application.routes.draw do
  namespace :admin do
      resources :items
      resources :accounts
      resources :customers
      resources :reservations
      root to: "accounts#index"
    end
  get "pages/home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "pages#home"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Sidekiq Admin Dash
  mount Sidekiq::Web => "/sidekiq"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  resources :items, only: [ :index, :show ] do
    resources :reservations, only: [ :new, :create ]
    resources :queue_positions, only: [] do # If you only want custom routes
      post "ping", action: :ping, on: :collection
      get "status/:reservation_id", action: :status, on: :collection
    end
  end
end
