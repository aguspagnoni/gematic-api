Rails.application.routes.draw do
  if Rails.env.development?
    mount Localtower::Engine, at: "localtower"
  end
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
