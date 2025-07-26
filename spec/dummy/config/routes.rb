Rails.application.routes.draw do
  resources :users
  resources :posts, only: %i[ show ]
  root "users#index"
end