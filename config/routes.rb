Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "tours#index"

  devise_for :users
  resources :tours
  resources :quizzes do
    post 'submit', on: :member
    post 'take', on: :member
    get 'take', on: :member
    post 'open', on: :member
    post 'close', on: :member
    resources :questions do
      resources :choices
    end
  end
  resources :attempts
  resources :choices do
    post 'correct', on: :member
  end
end
