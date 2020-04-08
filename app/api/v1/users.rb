# frozen_string_literal: true

module V1
  class Users < Grape::API
    namespace :users do
      desc 'User sign in'
      params do
        requires :email, type: String, desc: 'Email'
        requires :password, type: String, desc: 'Password'
      end
      post :sign_in do
        status :ok

        user = User.find_by(email: params[:email].downcase)
        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          {
            token: token
          }
        else
          error!('Unauthorized', 401)
        end
      end

      desc 'User info'
      get :current do
        authenticate!

        @user = current_user
        present @user, with: Entities::User
      end
    end
  end
end
