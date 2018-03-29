Myflix::Application.routes.draw do
  
  namespace :admin do
    resources :videos, only: [:new, :create]
  end

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

  get 'sign_in', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'

  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]

  resources :users, only: [:create, :show]
  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  resources :sessions, only: [:create]
  resources :categories, only: [:show]

  # virtual resources
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]
  
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired'

  resources :invitations, only: [:new, :create]
end
