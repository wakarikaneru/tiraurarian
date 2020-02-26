Rails.application.routes.draw do
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
  resources :points
  resources :mypage
  resources :search

  resources :controls

  namespace :admin do
    resources :controls
    resources :users
    resources :points
    resources :tweets
    resources :tags
    resources :goods
    resources :bads
    resources :bookmarks
    resources :follows
    resources :mutes

    root to: "controls#index"
  end

  get 'admin/index'

  get 'welcome/index'
  get 'tweets/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
