module JWTAuth
  extend ActiveSupport::Concern
  
  SECRET_KEY = '2ad5a69ab83d4cba69d844ea5a0ed542c3a3378972c6d431a6773f257bc3f37be3f49f9e67ee6ca2ee9854f2e0f4d8a769745a578d8d217bec7a3847f0980643'
  
  def encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end
  
  def decode(token)
    return nil if token.blank?
    
    Rails.logger.info "Decoding token: #{token}"
    Rails.logger.info "Using secret key: #{SECRET_KEY[0..10]}..."
    
    decoded = JWT.decode(token, SECRET_KEY)[0]
    Rails.logger.info "Decoded payload: #{decoded}"
    
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    Rails.logger.error "JWT Decode Error: #{e.message}"
    raise e
  rescue => e
    Rails.logger.error "General Error: #{e.message}"
    raise JWT::DecodeError.new("Token decode failed: #{e.message}")
  end
end 