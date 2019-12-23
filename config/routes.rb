Rails.application.routes.draw do
  resources :bookmarks
  devise_for :users

  root 'tweets#index'
  root to: "tweets#index"

  resources :tweets
  resources :users
  resources :follows
  resources :goods

  namespace :admin do
    resources :follows
    resources :admins
    resources :tweets
    resources :goods
    resources :users
  end

  get 'admin/index'

  get 'welcome/index'
  get 'tweets/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
