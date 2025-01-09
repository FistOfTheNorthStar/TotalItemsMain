require "sidekiq/web"

Rails.application.routes.draw do
  namespace :admin do
      resources :accounts
      root to: "accounts#index"
    end

  namespace :webhooks do
    namespace :shopify do
      post "order_cancelled" => "order#cancel"
      post "order_fulfilled" => "order#fulfill"
      post "order_refunded" => "order#refund"
      post "user_created" => "user#create"
      post "user_deleted" => "user#deleted"
    end

    namespace :chargebee do
      post 'handle', to: 'webhook#handle'
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Sidekiq Admin Dash
  mount Sidekiq::Web => "/sidekiq"
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
