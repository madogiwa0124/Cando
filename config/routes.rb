Rails.application.routes.draw do
  root 'tasks#index'
  resources :users
  resources :tasks do
    collection{ get :search }
  end
end
