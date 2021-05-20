Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  namespace :api, defaults: { format: :json } do
    post '/auth', to: 'authentication#create'
    get  '/auth', to: 'authentication#fetch'

    resources :students
    resources :groups
    resources :tasks
    resources :solutions
  end
end
