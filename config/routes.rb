Rails.application.routes.draw do

  get 'users/show'

  get 'users_controller/show'

  devise_for :users, controllers: {registrations: 'registrations'}
  resources :users, only: [:show]
  root 'pages#home'
  get  '/about',   to: 'pages#about'
  get  '/contact', to: 'pages#contact'
  get  '/help',    to: 'pages#help'

end
