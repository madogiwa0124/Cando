Rails.application.routes.draw do
  root 'user_sessions#new'
  resources :users
  resources :user_sessions, only: [:new, :create, :destroy]
  get  :login,  to: 'user_sessions#new', as: :login
  post :logout, to: 'user_sessions#destroy', as: :logout
  resources :tasks do
    collection{ get :search }
  end
end
