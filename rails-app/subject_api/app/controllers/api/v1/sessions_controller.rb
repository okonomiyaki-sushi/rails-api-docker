module Api
  module V1
    class SessionsController < ApplicationController
      before_action :check_token, except: :create

      # POST /api/v1/sessions
      def create
        user = User.find_by(email: login_params[:email])&.authenticate(login_params[:password])

        response_unauthorized("Authentication failure") and return if user.blank? || !user

        payload = {
          iss: "subject_api",
          sub: user.id,
          exp: (DateTime.current + 1.days).to_i
        }
    
        rsa_private = OpenSSL::PKey::RSA.new(File.read(Rails.root.join('auth/service.key')))
        token = JWT.encode(payload, rsa_private, "RS256")
        cookies[:token] = token
    
        response_success("Successful authentication") and return
    
      end

      private
      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
