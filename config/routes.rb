Rails.application.routes.draw do
  root 'application#lander'

  resource :app_services

  namespace :api do
    namespace :v1 do
      resources :apps, controller: '/app_services', only: %i(index show create options)
    end
  end
end
