Rails.application.routes.draw do
  resources :points
  devise_for :users

  root 'tweets#index'
  root to: "tweets#index"

  resources :tweets
  resources :users
  resources :follows
  resources :goods
  resources :bads
  resources :tags
  resources :bookmarks
  resources :mutes

  namespace :admin do
    resources :users
    resources :bads
    resources :tweets
    resources :bookmarks
    resources :follows
    resources :goods
    resources :mutes
    resources :tags

    root to: "users#index"
  end

  get 'admin/index'

  get 'welcome/index'
  get 'tweets/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
