Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "tours#index"

  devise_for :users
  resources :tours
  resources :quizzes do
    resources :questions do
      resources :choices
    end
  end
end
