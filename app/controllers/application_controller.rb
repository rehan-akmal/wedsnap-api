class ApplicationController < ActionController::API
  include JWTAuth
  
  before_action :authorize_request
  
  private
  
  def authorize_request
    header = request.headers['Authorization']
    Rails.logger.info "Authorization header: #{header}"
    
    if header.blank?
      Rails.logger.error "No authorization header provided"
      return render json: { errors: ['No authorization header provided'] }, status: :unauthorized
    end
    
    token = header.split(' ').last
    Rails.logger.info "Extracted token: #{token}"
    
    if token.blank?
      Rails.logger.error "No token provided"
      return render json: { errors: ['No token provided'] }, status: :unauthorized
    end
    
    begin
      decoded = decode(token)
      Rails.logger.info "Decoded result: #{decoded}"
      
      if decoded.nil?
        Rails.logger.error "Decoded token is nil"
        return render json: { errors: ['Invalid token format'] }, status: :unauthorized
      end
      
      user_id = decoded[:user_id] || decoded['user_id']
      Rails.logger.info "User ID from token: #{user_id}"
      
      if user_id.nil?
        Rails.logger.error "No user_id in token"
        return render json: { errors: ['Invalid token format'] }, status: :unauthorized
      end
      
      @current_user = User.find(user_id)
      Rails.logger.info "Found user: #{@current_user.email}"
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "User not found: #{e.message}"
      render json: { errors: ['User not found'] }, status: :unauthorized
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT Decode Error: #{e.message}"
      render json: { errors: ['Invalid token'] }, status: :unauthorized
    rescue => e
      Rails.logger.error "General error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { errors: ["Authorization failed: #{e.message}"] }, status: :unauthorized
    end
  end
end
