# config/routes.rb

Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      # Authentication
      post   'auth/signup', to: 'authentication#signup'
      post   'auth/login',  to: 'authentication#login'
      get    'auth/profile', to: 'authentication#profile'

      # Users
      resources :users, only: %i[index show create update destroy]

      # Availabilities
      resources :availabilities, except: %i[new edit]

      # Categories (public)
      resources :categories, only: %i[index show]

      # Gigs and nested resources
      resources :gigs do
        resources :packages,   except: %i[new edit], shallow: true
        resources :features,   except: %i[new edit], shallow: true
        resources :faqs,       except: %i[new edit], shallow: true
      end
    end
  end
end
