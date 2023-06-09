Rails.application.routes.draw do
  resources :articles
  resources :users
  resources :categories
  post '/signup', to: 'users#create'
  post '/login', to: 'users#login'
  get '/auto_login', to: 'users#auto_login'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
