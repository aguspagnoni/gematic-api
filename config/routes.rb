require 'sidekiq/web'

Rails.application.routes.draw do
  resources :product_inputs
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

  mount ForestLiana::Engine => '/forest'
  namespace :forest do
    post '/actions/autorizar'                        => 'price_lists#authorize_list'
    post '/actions/ver-resumen-lista'                => 'price_lists#send_summary'
    post '/actions/ver-pedido-por-mail'              => 'orders#send_summary'
    post '/actions/autorizar-pedido'                 => 'orders#authorize'
    post '/actions/descargar-pedido'                 => 'orders#download'
    post '/actions/duplicar-pedido'                  => 'orders#duplicate'
    post '/actions/cargar-productos-desde-lista'     => 'orders#from_price_list'
    post '/actions/cambiar-cantidad'                 => 'order_items#change_quantity'
  end
end
