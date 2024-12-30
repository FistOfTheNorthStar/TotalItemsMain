require "sidekiq/web"

Rails.application.routes.draw do
  namespace :admin do
      resources :items
      resources :accounts
      resources :customers
      resources :reservations
      root to: "accounts#index"
    end

  namespace :webhooks do
    namespace do
      post "shopify/paid" => "shopify#paid"
      post "shopify/payment_failed" => "shopify#payment_failed"
      post "shopify/refunded" => "shopify#refunded"
      post "shopify/user_created" => "shopify#user_created"
    end
  end
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Sidekiq Admin Dash
  mount Sidekiq::Web => "/sidekiq"
  mount ActionCable.server => "/cable"
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  
end
