Rails.application.routes.draw do

  get 'users/show'

  get 'users_controller/show'

  devise_for :users, controllers: {registrations: 'registrations'}
  resources :users, only: [:show]
  resources :playlists
  post 'playlists/display' => 'playlists#display', as: :display_playlist
  resources :articles do
    resources :comments
  end
  root 'pages#home'
  get  '/about',   to: 'pages#about'
  get  '/contact', to: 'pages#contact'
  get  '/help',    to: 'pages#help'

end
