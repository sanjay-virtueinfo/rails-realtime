FayeRailsDemo::Application.routes.draw do
  faye_server '/faye', timeout: 25 do
    map '/listing' => RealtimeListingController
    map default: :block
  end

  resources :chat

  resources :users
  resources :user_sessions
  resources :schools

  get 'logout' => 'user_sessions#destroy', :as => :logout
  get 'login' => 'user_sessions#new', :as => :login
  match 'signup(/:registration_key)' => 'user_sessions#signup', :as => :signup, via: [:get, :post, :patch]

  match '/forgot_password' => 'fronts#forgot_password', :as => :forgot_password, via: [:get, :post]
  match '/change_password' => 'fronts#change_password', :as => :change_password, via: [:get, :post, :patch]
  get '/settings' => 'fronts#settings', :as => :settings
  get 'dashboard' => 'fronts#dashboard', :as => :dashboard
  match 'activate/:activation_key' => 'fronts#user_activation', :as => :activation_link, via: [:get]
  match '/profile' => 'fronts#profile', :as => :profile, via: [:get, :post, :patch]

  # You can have the root of your site routed with "root"
  root to: 'fronts#dashboard'

  
#  root to: 'chat#index'
end
