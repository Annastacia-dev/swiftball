Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "tours#index"

  get 'terms_and_conditions', to: 'tours#terms_and_conditions'
  get 'privacy_policy', to: 'tours#privacy_policy'

  devise_for :users
  resources :tours
  resources :quizzes do
    post 'submit', on: :member
    post 'take', on: :member
    get 'take', on: :member
    get 'results', on: :member
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
end
