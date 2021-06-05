Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  namespace :api, defaults: { format: :json } do
    post '/auth', to: 'authentication#create'
    get  '/auth', to: 'authentication#fetch'
    patch '/auth/password', to: 'authentication#update_password'

    resource :settings, only: [:show, :update]

    resources :students do
      delete 'batch_destroy', on: :collection
    end
    resources :groups do
      delete 'batch_destroy', on: :collection
    end
    resources :tasks do
      delete 'batch_destroy', on: :collection
      post   'create_by_file', on: :collection
    end

    resources :solutions
    resources :attempts do
      delete 'destroy_all', on: :collection
    end
  end
end
