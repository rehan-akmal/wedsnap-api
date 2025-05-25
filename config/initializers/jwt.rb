module JWTAuth
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.credentials.jwt_secret)
    end
  
    def decode(token)
      body = JWT.decode(token, Rails.application.credentials.jwt_secret)[0]
      HashWithIndifferentAccess.new(body)
    rescue JWT::DecodeError
      nil
    end
  end
  