Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions', registrations: 'registrations'}

  root 'main#index'
  scope :api do
    resources :images, only: :create
    resources :users
    resources :categories
    resources :recipes do
      resources :comments
      resources :steps
    end
  end
end
