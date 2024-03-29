Rails.application.routes.draw do
  namespace :admin do
    get 'dashboard/index'
    resources :notification_settings, only: %i[edit update]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Defines the root path route ("/")
  root 'admin/dashboard#index'
end
