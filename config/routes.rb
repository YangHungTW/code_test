Rails.application.routes.draw do

  root 'users#show'

  resources :registrations, only: [:create, :update]

  get  'sign_up', to: 'registrations#new',    as: 'sign_up'
  post 'sign_up', to: 'registrations#create', as: 'create_user'
  get  'edit',    to: 'registrations#edit',   as: 'edit_user'
  put  'edit',    to: 'registrations#update', as: 'update_user'

  get    'login',  to: 'sessions#new',     as: 'new_login'
  post   'login',  to: 'sessions#create',  as: 'login'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  get  'forgot', to: 'passwords#new',    as: 'new_forgot_password'
  post 'forgot', to: 'passwords#create', as: 'forgot_password'
  get  'reset',  to: 'passwords#edit',   as: 'reset_password'
  put  'reset',  to: 'passwords#update', as: 'update_password'

end
