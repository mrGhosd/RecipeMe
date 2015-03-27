Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions', registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks'}

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  root 'main#index'

  concern :users_liked do
    get :liked_users, on: :member
  end

  concern :rate do
    post :rating
  end

  scope :api do
    resources :images, only: :create
    resources :relationships, only: [:create, :destroy]
    resources :users do
      get :following, on: :member
      get :followers, on: :member
    end
    resources :callbacks
    resources :news, concerns: [:rate, :users_liked]
    resources :ingridients, only: [:index]
    resources :categories do
      get :recipes, on: :member
    end
    resources :recipes, concerns: [:rate, :users_liked] do
      resources :ingridients, except: :index do
        get :index, on: :collection, to: "ingridients#recipe_ingridients"
      end
      resources :comments, concerns: [:rate, :users_liked]
      resources :steps
    end
  end
end
