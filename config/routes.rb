Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  namespace :users do
    resources :contributions, only: [:index]
  end
  resources :locations, only: [:index, :show, :new, :create, :edit, :update] do
    resources :comments, only: [:index, :create]
  end
  resources :locations, only: [:destroy]
  resources :contributions, only: [:new, :create, :edit, :update, :destroy]
  resources :news, only: [:index]
end
