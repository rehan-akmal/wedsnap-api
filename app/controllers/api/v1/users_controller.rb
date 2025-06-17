# app/controllers/api/v1/users_controller.rb
module Api
    module V1
      class UsersController < ApplicationController
        # GET /api/v1/users
        def index
          users = User.page(params[:page]).per(params[:per_page] || 20)
          render json: users, each_serializer: UserSerializer
        end
  
        # GET /api/v1/users/:id
        def show
          user = User.find(params[:id])
          render json: user, serializer: UserSerializer
        end
  
        # POST /api/v1/users
        def create
          user = User.new(user_params)
          if user.save
            render json: user, serializer: UserSerializer, status: :created
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # PUT/PATCH /api/v1/users/:id
        def update
          user = User.find(params[:id])
          if user.update(user_params)
            render json: user, serializer: UserSerializer
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # DELETE /api/v1/users/:id
        def destroy
          User.find(params[:id]).destroy
          head :no_content
        end

        # GET /api/v1/users/:id/availability
        def availability
          user = User.find(params[:id])
          availabilities = user.availabilities.ordered_by_date
          render json: availabilities, each_serializer: Api::V1::AvailabilitySerializer
        end
  
        private
  
        def user_params
          params.require(:user).permit(
            :name, :email, :password, :password_confirmation,
            :bio, :location, :phone, :role, :avatar
          )
        end
      end
    end
  end
  