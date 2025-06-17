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

        # GET /api/v1/users/settings
        def settings
          render json: {
            name: @current_user.name,
            email: @current_user.email,
            bio: @current_user.bio,
            location: @current_user.location,
            phone: @current_user.phone,
            avatar_url: @current_user.avatar_url,
            notifications: @current_user.notification_settings,
            availability: @current_user.availability_settings,
            estimate_calculator: @current_user.estimate_calculator_settings
          }
        end

        # PUT /api/v1/users/update_notification_settings
        def update_notification_settings
          current_settings = @current_user.settings
          current_settings['notifications'] = notification_settings_params
          @current_user.settings = current_settings
          
          if @current_user.save
            render json: { message: 'Notification settings updated successfully' }
          else
            render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/users/update_availability_settings
        def update_availability_settings
          current_settings = @current_user.settings
          current_settings['availability'] = availability_settings_params
          @current_user.settings = current_settings
          
          if @current_user.save
            render json: { message: 'Availability settings updated successfully' }
          else
            render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/users/update_estimate_calculator_settings
        def update_estimate_calculator_settings
          current_settings = @current_user.settings
          current_settings['estimate_calculator'] = estimate_calculator_settings_params
          @current_user.settings = current_settings
          
          if @current_user.save
            render json: { message: 'Estimate calculator settings updated successfully' }
          else
            render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # GET /api/v1/users/:id/estimate_calculator_settings
        def estimate_calculator_settings
          user = User.find(params[:id])
          render json: user.estimate_calculator_settings
        end
  
        private
  
        def user_params
          params.require(:user).permit(
            :name, :email, :password, :password_confirmation,
            :bio, :location, :phone, :role, :avatar
          )
        end

        def notification_settings_params
          params.require(:notifications).permit(:email, :messages, :orders, :marketing)
        end

        def availability_settings_params
          params.require(:availability).permit(:days, :startTime, :endTime)
        end

        def estimate_calculator_settings_params
          params.require(:estimate_calculator).permit(
            :photography_coverage, :videography_coverage, :drone_footage,
            :gimbal_stabilizer, :basic_color_correction, :advanced_editing_package,
            :express_delivery_surcharge
          )
        end
      end
    end
  end
  