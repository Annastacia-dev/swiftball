Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root "tours#index"
  get "up" => "rails/health#show", as: :rails_health_check
  get '/stats(/:id)', to: 'home#stats', as: :stats
  get 'terms_and_conditions', to: 'home#terms_and_conditions'
  get 'privacy_policy', to: 'home#privacy_policy'
  get 'disclaimer', to: 'home#disclaimer'
  get 'leaderboard', to: 'home#leaderboard'

  devise_for :users, :controllers => {:registrations => "registrations" }
  resources :tours
  resources :quizzes do
    post 'submit', on: :member
    post 'take', on: :member
    get 'take', on: :member
    get 'results', on: :member
    get 'progress', on: :member
    post 'open', on: :member
    post 'close', on: :member
    post 'live', on: :member
    resources :questions do
      get 'pick_surprise_song', on: :member
      post 'surprise_song_answer', on: :member
      resources :choices
    end
  end
  resources :attempts
  resources :choices do
    post 'correct', on: :member
    post 'incorrect', on: :member
  end
  resources :albums do
    resources :songs
  end

  resources :responses do
    resources :mashup_answers, only: :index
  end

  resources :mashup_answers, only: %i[edit update destroy new create]

  resources :users do
    get 'unsubscribe', on: :member
    get 'subscribe', on: :member
  end
  resources :outfits

  resources :push_subscriptions, only: [:create]
  resources :push_notifications, only: [:create]
end
