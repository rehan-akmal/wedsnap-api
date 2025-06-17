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

      # Super Admin Dashboard
      # Dashboard Overview
      get 'super_admin/dashboard/overview', to: 'super_admin#dashboard_overview'
      
      # Analytics
      get 'super_admin/analytics/users', to: 'super_admin#user_analytics'
      get 'super_admin/analytics/gigs', to: 'super_admin#gig_analytics'
      get 'super_admin/analytics/communications', to: 'super_admin#communication_analytics'
      get 'super_admin/analytics/system', to: 'super_admin#system_analytics'
      
      # User Management
      get 'super_admin/users', to: 'super_admin#users_list'
      get 'super_admin/users/:id', to: 'super_admin#user_details'
      put 'super_admin/users/:id/role', to: 'super_admin#update_user_role'
      delete 'super_admin/users/:id', to: 'super_admin#delete_user'
      
      # Gig Management
      get 'super_admin/gigs', to: 'super_admin#gigs_list'
      get 'super_admin/gigs/:id', to: 'super_admin#gig_details'
      delete 'super_admin/gigs/:id', to: 'super_admin#delete_gig'
      
      # Category Management
      get 'super_admin/categories', to: 'super_admin#categories_list'
      post 'super_admin/categories', to: 'super_admin#create_category'
      put 'super_admin/categories/:id', to: 'super_admin#update_category'
      delete 'super_admin/categories/:id', to: 'super_admin#delete_category'
      
      # System Settings
      get 'super_admin/system/settings', to: 'super_admin#system_settings'

      # Users
      resources :users, only: %i[index show create update destroy] do
        member do
          get :availability
          get :estimate_calculator_settings
        end
        collection do
          get :settings
          put :update_notification_settings
          put :update_availability_settings
          put :update_estimate_calculator_settings
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
