Rails.application.routes.draw do
  root 'application#lander'

  resource :app_services

  match '/api/v1/apps', to: 'app_services#index', via: [:get]
  match '/api/v1/apps', to: 'app_services#save', via: [:post]
  match '/api/v1/apps', to: 'app_services#destroy', via: [:delete]
  namespace :api do
    namespace :v1 do
      match 'apps', to: 'app_services#save', via: [:post]
      match 'apps', to: 'app_services#index', via: [:get]
      # post 'apps', action: :save, controller: '/app_services'
      # get 'apps', action: :index, controller: '/app_services'
      match 'apps', to: 'app_services#delete', via: [:delete]
    end
  end
end
