Rails.application.routes.draw do
  mount Localtower::Engine, at: 'localtower' if Rails.env.development?

  post 'user_token' => 'user_token#create'
  resources :admin_users
  resources :discounts
  resources :price_lists
  resources :billing_infos
  resources :users
  resources :categories
  resources :claims
  resources :orders
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
