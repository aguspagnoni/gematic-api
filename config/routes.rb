require 'sidekiq/web'

Rails.application.routes.draw do
  mount ForestLiana::Engine => '/forest'
  resources :branch_offices
  mount Localtower::Engine, at: 'localtower' if Rails.env.development?
  mount Sidekiq::Web => '/sidekiq'

  post 'user_token' => 'user_token#create'
  resources :admin_users
  resources :discounts
  resources :price_lists
  resources :billing_infos
  resources :users do
    post :confirm, on: :collection
  end
  resources :categories
  resources :claims
  resources :orders
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
