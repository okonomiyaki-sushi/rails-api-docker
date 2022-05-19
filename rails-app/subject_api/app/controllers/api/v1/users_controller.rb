module Api
  module V1
    class UsersController < ApplicationController
      
      # POST /api/v1/users
      def create
        user = User.new(user_params)
        if user.save
          response_created("Created a user") and return
        else
          response_bad_request(user.errors.full_messages) and return
        end
      end

      private
      def user_params
        params.permit(:email, :password).merge(password_confirmation: params[:password])
      end
      
    end
  end
end