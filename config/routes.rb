Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }

  root 'tweets#index'
  root to: "tweets#index"

  get 'notification', to: 'application#notification'
  get 'load', to: 'application#load'
  get 'stat', to: 'application#stat'
  get 'offline', to: 'application#offline'

  resources :tweets
  get 'tweets_async', to: 'tweets#async'
  resources :texts
  resources :tags
  resources :bookmarks
  resources :goods
  resources :bads

  resources :search

  resources :users
  resources :follows
  resources :mutes

  resources :notices
  resources :messages

  resources :card_boxes
  resources :cards
  resources :card_decks

  resources :points do
    collection do
      post 'remit'
    end
  end

  resources :mypage

  get 'stock', to: 'stocks#index'
  post 'stock/purchase', to: 'stocks#purchase'
  post 'stock/sale', to: 'stocks#sale'

  get 'taxpayers', to: 'taxpayers#index'

  get 'info/index'
  get 'info/howtouse'
  get 'info/termsofservice'
  get 'info/privacypolicy'
  get 'info/whatisvarth'

  namespace :admin do
    resources :access_logs
    resources :stats
    resources :controls

    resources :tweets
    resources :texts
    resources :tags
    resources :bookmarks
    resources :goods
    resources :bads

    resources :users
    resources :follows
    resources :mutes

    resources :notices
    resources :messages

    resources :points
    resources :taxpayers
    resources :taxpayer_hofs

    resources :card_boxes
    resources :cards
    resources :card_decks

    resources :stocks

    resources :thumbs

    root to: "controls#index"
  end

  get 'admin/index'

  get 'welcome/index'
  get 'tweets/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
