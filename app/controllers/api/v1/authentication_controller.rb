# app/controllers/api/v1/authentication_controller.rb
module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authorize_request, only: [:login, :signup, :test_auth]

      # POST /api/v1/auth/signup
      def signup
        user = User.new(user_params)
        user.role = 'user' # Set default role for new users
        if user.save
          token = encode(user_id: user.id, role: user.role)
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
          token = encode(user_id: user.id, role: user.role)
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
      
      # GET /api/v1/auth/test
      def test_auth
        header = request.headers['Authorization']
        if header.blank?
          return render json: { error: 'No Authorization header provided' }, status: :bad_request
        end
        
        token = header.split(' ').last
        
        begin
          decoded = decode(token)
          user = User.find(decoded[:user_id])
          render json: { 
            message: 'Token is valid', 
            decoded: decoded,
            user: user.as_json(only: %i[id name email role])
          }, status: :ok
        rescue ActiveRecord::RecordNotFound => e
          render json: { error: 'User not found', user_id: decoded[:user_id] }, status: :not_found
        rescue JWT::ExpiredSignature => e
          render json: { error: 'Token has expired' }, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: { error: 'Invalid token', details: e.message }, status: :unauthorized
        rescue => e
          render json: { error: 'Authentication failed', details: e.message }, status: :unauthorized
        end
      end

      # GET /api/v1/auth/profile
      def profile
        render json: {
          id: @current_user.id,
          name: @current_user.name,
          email: @current_user.email,
          bio: @current_user.bio,
          location: @current_user.location,
          phone: @current_user.phone,
          role: @current_user.role,
          avatar_url: @current_user.avatar_url,
          notifications: @current_user.notification_settings,
          availability: @current_user.availability_settings
        }, status: :ok
      end

      # PUT /api/v1/auth/profile
      def update_profile
        if @current_user.update(profile_params)
          render json: @current_user.as_json(
            only: %i[id name email bio location phone role],
            methods: [:avatar_url]
          ), status: :ok
        else
          render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/auth/profile/avatar
      def upload_avatar
        if params[:profileImage].present?
          @current_user.avatar.attach(params[:profileImage])
          render json: { 
            message: 'Avatar uploaded successfully',
            imageUrl: @current_user.avatar_url
          }, status: :ok
        else
          render json: { errors: ['No image file provided'] }, status: :bad_request
        end
      end

      # PUT /api/v1/auth/password
      def update_password
        if @current_user.password != params[:currentPassword]
          return render json: { errors: ['Current password is incorrect'] }, status: :unauthorized
        end

        if params[:newPassword].blank?
          return render json: { errors: ['New password cannot be blank'] }, status: :unprocessable_entity
        end

        @current_user.password = params[:newPassword]
        if @current_user.save
          render json: { message: 'Password updated successfully' }, status: :ok
        else
          render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/auth/notifications
      def update_notifications
        # Store notification preferences in user settings or a separate model
        # For now, we'll store them as JSON in a settings column
        settings = @current_user.settings || {}
        settings['notifications'] = {
          email: params[:email],
          messages: params[:messages],
          orders: params[:orders],
          marketing: params[:marketing]
        }
        
        @current_user.settings = settings
        if @current_user.save
          render json: { message: 'Notification settings updated successfully' }, status: :ok
        else
          render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/auth/availability
      def update_availability
        # Store availability settings in user settings
        settings = @current_user.settings || {}
        settings['availability'] = {
          days: params[:days],
          startTime: params[:startTime],
          endTime: params[:endTime]
        }
        
        @current_user.settings = settings
        if @current_user.save
          render json: { message: 'Availability settings updated successfully' }, status: :ok
        else
          render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/auth/account
      def delete_account
        if @current_user.destroy
          render json: { message: 'Account deleted successfully' }, status: :ok
        else
          render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password)
      end

      def profile_params
        params.require(:user).permit(:name, :email, :bio, :location, :phone)
      end
    end
  end
end
