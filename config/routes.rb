Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'
  resources :videos, only: [:index, :show] do
  	collection do
  		get 'search', to: 'videos#search'
  	end
    resources :reviews, only: [:create]
  end
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'
  resources :users, only: [:create, :new]
  resources :sessions, only: [:create]
end
