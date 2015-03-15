Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions', registrations: 'registrations'}

  root 'main#index'
  concern :rate do
    post :rating
  end

  scope :api do
    resources :images, only: :create
    resources :users
    resources :categories do
      get :recipes, on: :member
    end
    resources :recipes, concerns: :rate do
      resources :comments, concerns: :rate
      resources :steps
    end
  end
end
