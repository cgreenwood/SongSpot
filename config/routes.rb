Rails.application.routes.draw do
  get 'users/show'

  get 'users_controller/show'

  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: [:show]
  resources :playlists, only: [:new, :show]
  resources :bugs
  resources :articles do
    resources :comments, only: [:create]
  end
  root 'pages#home'
  post 'playlists/display' => 'playlists#display', as: :display_playlist
  get  '/about',   to: 'pages#about'
  get  '/contact', to: 'pages#contact'
  get  '/help',    to: 'pages#help'
end
