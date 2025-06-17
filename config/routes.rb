# config/routes.rb
require 'sidekiq/web'

Rails.application.routes.draw do

  # Sidekiq web interface (protect in production)
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      # Authentication
      post   'auth/signup', to: 'authentication#signup'
      post   'auth/login',  to: 'authentication#login'
      get    'auth/profile', to: 'authentication#profile'
      put    'auth/profile', to: 'authentication#update_profile'
      post   'auth/profile/avatar', to: 'authentication#upload_avatar'
      put    'auth/password', to: 'authentication#update_password'
      put    'auth/notifications', to: 'authentication#update_notifications'
      put    'auth/availability', to: 'authentication#update_availability'
      delete 'auth/account', to: 'authentication#delete_account'
      get    'auth/test', to: 'authentication#test_auth'

      # Dashboard
      get 'dashboard/seller/stats', to: 'dashboard#seller_stats'
      get 'dashboard/buyer/stats', to: 'dashboard#buyer_stats'
      get 'dashboard/overview', to: 'dashboard#overview'

      # Users
      resources :users, only: %i[index show create update destroy] do
        member do
          get :availability
        end
      end

      # Availabilities
      resources :availabilities, except: %i[new edit] do
        collection do
          get 'check/:date', to: 'availabilities#check'
        end
      end

      # Categories (public)
      resources :categories, only: %i[index show]

      # Conversations and Messages
      resources :conversations, only: %i[index show create] do
        member do
          put :read, to: 'conversations#mark_as_read'
        end
        resources :messages, only: %i[index create] do
          member do
            put :read, to: 'messages#mark_as_read'
          end
        end
      end

      # Gigs and nested resources
      resources :gigs do
        resources :packages,   except: %i[new edit], shallow: true
        resources :features,   except: %i[new edit], shallow: true
        resources :faqs,       except: %i[new edit], shallow: true
      end
    end
  end
end
