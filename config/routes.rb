Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  namespace :api, defaults: { format: :json } do
    namespace :users do
      post '/auth', to: 'authentication#create'
      get  '/auth', to: 'authentication#fetch'
    end
  end
end
