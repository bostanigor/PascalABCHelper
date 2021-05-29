Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  namespace :api, defaults: { format: :json } do
    post '/auth', to: 'authentication#create'
    get  '/auth', to: 'authentication#fetch'
    patch '/auth/password', to: 'authentication#update_password'

    resources :students
    resources :groups
    resources :tasks
    resources :solutions
    resources :attempts
  end
end
