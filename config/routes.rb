Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'pages#home'
  namespace :users do
    resources :contributions, only: [:index]
    resources :checkin, only: [:new, :create]
  end
  resources :locations do
    resources :comments, only: [:index, :create] # check where goes the comments
    resources :contributions, only: [:new, :create]
    resources :checkin, only: [:update, :destroy]
  end
  resources :contributions, only: [:edit, :update, :destroy]
  resources :news, only: [:index]
end
