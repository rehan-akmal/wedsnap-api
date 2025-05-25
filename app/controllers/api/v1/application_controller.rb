# app/controllers/api/v1/application_controller.rb
module Api
    module V1
      class ApplicationController < ActionController::API
        include JWTAuth
  
        before_action :authorize_request
  
        private
  
        def authorize_request
          header = request.headers['Authorization']
          token  = header&.split&.last
          decoded = decode(token)
          @current_user = User.find(decoded[:user_id])
        rescue
          render json: { errors: ['Not Authorized'] }, status: :unauthorized
        end
      end
    end
  end
  