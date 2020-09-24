Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  delete 'sessions/destroy', to: 'sessions#destroy'
  resources :posts
  resources :users, only: [:new,:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "posts#index"
end
