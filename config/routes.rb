Rails.application.routes.default_url_options[:host] = 'http://localhost:3000' if Rails.env == "development"
Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  use_doorkeeper
  mount Sidekiq::Monitor::Engine => '/sidekiq'
  devise_for :users, controllers: {sessions: 'sessions', registrations: 'registrations', passwords: 'passwords', omniauth_callbacks: 'omniauth_callbacks'}

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
    get "/search/:data", to: "application#search"

    resources :images, only: :create
    resources :relationships, only: [:create, :destroy]
    resources :users do
      post :reset_password, on: :collection
      post :generate_new_password_email, on: :collection
      resources :feeds, only: [:index, :show]
      get :following, on: :member
      get :recipes, on: :member
      get :comments, on: :member
      post :locale, on: :collection
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

  namespace :api do
    namespace :v1 do
      post "/users/update_profile", to: "users#update_profile"
      resources :categories do
        member { get :recipes }
      end
      resources :relationships, only: [:create, :destroy]
      resources :images, only: :create
      resources :recipes, concerns: [:rate] do
        resources :comments, concerns: [:rate]
        resources :steps
        resources :ingridients
      end
      resources :complaints
      resources :users do
        get '/:entity', to: "users#info"
        collection do
          # match :update, via: [:post, :put]
          get :profile
          get :own_feed
          get :feed
        end

      end
    end
  end
end
