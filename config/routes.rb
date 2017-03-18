Rails.application.routes.draw do
  resources :admin_users
  resources :discounts
  resources :price_lists
  resources :billing_infos
  resources :clients
  resources :categories
  resources :claims
  resources :orders
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
