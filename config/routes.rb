Rails.application.routes.draw do


  get 'home' => 'static_pages#home'
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'sign_up' => 'users#new'

  get 'login' => "sessions#new"
  post 'login' => "sessions#create"
  get 'logout' => "sessions#destroy"

  root 'static_pages#home'

  resources :users





  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
