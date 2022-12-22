Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]
  resources :styles

  resources :breweries do
    post 'toggle_activity', on: :member
  end

  resources :users do
    post 'block_user', on: :member
  end

  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  get 'signup', to: 'users#new'
  delete 'delete_rating', to: 'ratings#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post 'places', to: 'places#search'

  # Defines the root path route ("/")
  root 'breweries#index'
  #get 'ratings', to: 'ratings#index'
  #get 'ratings/new', to:'ratings#new'
  #post 'ratings', to: 'ratings#create'
  resources :ratings, only: [:index, :new, :create, :destroy]
end

