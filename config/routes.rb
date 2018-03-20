Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'
  resources :videos, only: [:index, :show] do
  	collection do
  		get 'search', to: 'videos#search'
  	end
    resources :reviews, only: [:create]
  end
  resources :queue_items, only: [:create, :destroy]
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update'

  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'

  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]

  resources :users, only: [:create, :new, :show]
  resources :sessions, only: [:create]
  resources :categories, only: [:show]
end
