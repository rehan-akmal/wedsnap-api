# app/controllers/api/v1/authentication_controller.rb
module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authorize_request, only: [:login, :signup]

      # POST /api/v1/auth/signup
      def signup
        user = User.new(user_params)
        user.role = 'user' # Set default role for new users
        if user.save
          token = encode(user_id: user.id)
          render json: {
            token: token,
            user: user.as_json(
              only: %i[id name email role],
              methods: [:avatar_url]
            )
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/auth/login
      def login
        user = User.find_by(email: params[:email])
        if user && user.password == params[:password]
          token = encode(user_id: user.id)
          render json: {
            token: token,
            user: user.as_json(
              only: %i[id name email bio location phone role],
              methods: [:avatar_url]
            )
          }, status: :ok
        else
          render json: { errors: ['Invalid email or password'] }, status: :unauthorized
        end
      end
      

      # GET /api/v1/auth/profile
      def profile
        render json: @current_user.as_json(
          only: %i[id name email bio location phone role],
          methods: [:avatar_url]
        ), status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
