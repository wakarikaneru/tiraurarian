Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }

  get 'tests/tests'
  get 'tests/test1'
  get 'index2', to: 'tweets#index2'

  root to: "tweets#index"

  get 'notification', to: 'application#notification'
  get 'news', to: 'application#news'
  get 'load', to: 'application#load'
  get 'stat', to: 'application#stat'
  post 'set_locale', to: 'application#set_locale'
  get 'offline', to: 'application#offline'

  resources :tweets
  get 'tweets_async', to: 'tweets#async'
  get 'leaning/study', to: 'tweets#study'
  post 'superuser/nsfw_tweet', to: 'superuser#nsfw_tweet'
  post 'superuser/delete_tweet', to: 'superuser#delete_tweet'
  post 'superuser/ban_1h', to: 'superuser#ban_1h'
  post 'superuser/ban_1d', to: 'superuser#ban_1d'
  post 'superuser/ban_1w', to: 'superuser#ban_1w'
  post 'superuser/ban_1m', to: 'superuser#ban_1m'
  resources :texts
  resources :tags
  resources :bookmarks
  resources :goods
  resources :wakarus
  resources :bads

  resources :search

  resources :users
  resources :follows
  resources :mutes

  resources :notices
  resources :messages

  get 'premium', to: 'premium#index'
  post 'premium/create', to: 'premium#create'

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
  get 'stock/info', to: 'stocks#info'
  get 'stock/stock_log', to: 'stocks#stock_log'
  post 'stock/purchase', to: 'stocks#purchase'
  post 'stock/sale', to: 'stocks#sale'

  get 'gambling', to: 'gambling#index'
  get 'gambling/gambling', to: 'gambling#gambling'
  post 'gambling/gambling', to: 'gambling#gambling'

  get 'card_battle', to: 'card_battle#index'
  get 'card_battle/standby', to: 'card_battle#standby'
  get 'card_battle/battle', to: 'card_battle#battle'
  post 'card_battle/purchase', to: 'card_battle#purchase'
  post 'card_battle/gacha', to: 'card_battle#gacha'
  post 'card_battle/trial_gacha', to: 'card_battle#trial_gacha'
  post 'card_battle/judge', to: 'card_battle#judge'
  post 'card_battle/expand_box', to: 'card_battle#expand_box'

  get 'card/select_send_card', to: 'cards#select_send_card'
  post 'card/send_card', to: 'cards#send_card'
  get 'card/dumpsite', to: 'cards#dumpsite'
  post 'card/dump', to: 'cards#dump'

  get 'card_deck/creater', to: 'card_decks#creater'

  resources :tiramons
  get 'tiramon/ranks', to: 'tiramons#ranks'
  get 'tiramon/adventure', to: 'tiramons#adventure'
  post 'tiramon/fusion_get', to: 'tiramons#fusion_get'
  post 'tiramon/get', to: 'tiramons#get'
  post 'tiramon/scout', to: 'tiramons#scout'
  post 'tiramon/training', to: 'tiramons#training'
  post 'tiramon/set_style', to: 'tiramons#set_style'
  post 'tiramon/set_wary', to: 'tiramons#set_wary'
  post 'tiramon/set_move', to: 'tiramons#set_move'
  post 'tiramon/get_move', to: 'tiramons#get_move'
  post 'tiramon/inspire_move', to: 'tiramons#inspire_move'
  post 'tiramon/refresh', to: 'tiramons#refresh'
  post 'tiramon/rename', to: 'tiramons#rename'
  post 'tiramon/set_entry', to: 'tiramons#set_entry'
  post 'tiramon/release', to: 'tiramons#release'
  get 'tiramon/edit_move', to: 'tiramons#edit_move'

  resources :tiramon_battles
  get 'tiramon_battle', to: 'tiramon_battles#index'
  get 'tiramon_battle/show_realtime', to: 'tiramon_battles#show_realtime'
  get 'tiramon_battle/results', to: 'tiramon_battles#results'
  get 'tiramon_battle/rank_results', to: 'tiramon_battles#rank_results'
  get 'tiramon_battle/adventure_battle', to: 'tiramon_battles#adventure_battle'

  post 'tiramon_bet/bet', to: 'tiramon_bet#bet'

  get 'tiramon_trainer', to: 'tiramon_trainers#index'
  post 'tiramon_trainer/move_recovery', to: 'tiramon_trainers#move_recovery'
  post 'tiramon_trainer/get_ball', to: 'tiramon_trainers#get_ball'

  get 'taxpayers', to: 'taxpayers#index'

  get 'info/index'
  get 'info/howtouse'
  get 'info/termsofservice'
  get 'info/privacypolicy'
  get 'info/whatisvarth'

  namespace :admin do
    resources :access_logs
    resources :error_logs

    resources :permissions
    resources :bans
    resources :delete_logs

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

    resources :premia

    resources :points
    resources :taxpayers
    resources :taxpayer_hofs

    resources :card_kings
    resources :card_boxes
    resources :cards
    resources :card_decks

    resources :stocks
    resources :stock_trade_logs
    resources :stock_logs
    resources :gambling_results

    resources :thumbs

    resources :tiramon_trainers
    resources :tiramons
    resources :tiramon_moves
    resources :tiramon_trainings
    resources :tiramon_battles
    resources :tiramon_battle_prizes
    resources :tiramon_factors
    resources :tiramon_factor_names

    resources :tiramon_enemies
    resources :tiramon_templates

    root to: "controls#index"
  end

  require 'sidekiq/web'

  authenticate :user, ->(user) { user.id == 1 } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
