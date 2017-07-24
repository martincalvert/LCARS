Rails.application.routes.draw do
  root 'application#lander'

  # Settings Routes
  match 'api/v1/settings', to: 'settings#load', via: [:get]
  match 'api/v1/settings', to: 'settings#save', via: [:post]

  # Settings Routes
  match 'api/v1/statuses/:environment', to: 'statuses#index', via: [:get], format: :json

  # Apps Routes
  match '/api/v1/apps', to: 'app_services#index', via: [:get]
  match '/api/v1/apps', to: 'app_services#save', via: [:post]
  match '/api/v1/apps', to: 'app_services#destroy', via: [:delete]
end
