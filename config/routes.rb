Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'pages#home'
  namespace :users do
    resources :contributions, only: [:index]
  end
  resources :locations do
    resources :comments, only: [:index, :create] # check where goes the comments
    resources :contributions, only: [:new, :create]
    resources :checkins, only: [:create]
  end
  resources :contributions, only: [:edit, :update, :destroy]
  resources :news, only: [:index]
end
