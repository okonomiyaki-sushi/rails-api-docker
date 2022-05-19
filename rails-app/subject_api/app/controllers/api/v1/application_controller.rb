module Api
  module V1
    class ApplicationController < ActionController::API
      include ::ActionController::Caching
      include ActionController::Cookies
      include ApiResponseHelper
      self.cache_store = :mem_cache_store
      rescue_from ActiveRecord::RecordNotFound, with: :response_not_found

      def check_token
        token = cookies[:token]
    
        rsa_private = OpenSSL::PKey::RSA.new(File.read(Rails.root.join('auth/service.key')))
    
        begin
          decoded_token = JWT.decode(token, rsa_private, true, { algorithm: 'RS256' })
        rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
          response_unauthorized("Authentication failure") and return
        end
    
        @user = User.find(decoded_token.first["sub"])
        response_unauthorized("Authentication failure") and return if @user.nil?

      end

    end
  end
end