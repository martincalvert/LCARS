Rails.application.routes.draw do
  root 'application#entrypoint'

  match 'health', to: 'application#health', via: %i[get options], format: :json

  # Settings Routes
  match 'api/v1/settings', to: 'settings#load', via: [:get]
  match 'api/v1/settings', to: 'settings#save', via: [:post]

  # Settings Routes
  match 'api/v1/statuses/:environment', to: 'services#index', via: [:get], format: :json

  # Apps Routes
  match '/api/v1/apps', to: 'services#index', via: [:get]
  match '/api/v1/apps', to: 'services#save', via: [:post]
  match '/api/v1/apps', to: 'services#destroy', via: [:delete]
end
