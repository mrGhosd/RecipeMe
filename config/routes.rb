Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions', registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks'}

  root 'main#index'

  concern :users_liked do
    get :liked_users, on: :member
  end

  concern :rate do
    post :rating
  end

  scope :api do
    resources :images, only: :create
    resources :users
    resources :callbacks
    resources :news, concerns: [:rate, :users_liked]
    resources :ingridients
    resources :categories do
      get :recipes, on: :member
    end
    resources :recipes, concerns: [:rate, :users_liked] do
      resources :comments, concerns: [:rate, :users_liked]
      resources :steps
    end
  end
end
