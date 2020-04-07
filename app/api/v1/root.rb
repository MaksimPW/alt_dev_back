# frozen_string_literal: true

module V1
  class Root < Grape::API
    version 'v1'
    format :json

    helpers do
      def authenticate!
        error!('Invalid token', 401) unless current_user
      end

      def current_user
        token = JsonWebToken.decode(http_auth_header)
        @current_user = User.find(token[:user_id]) if token
      end

      def http_auth_header
        return headers['Authorization'].split(' ').last if headers['Authorization'].present?

        error!('Missing token', 401)
      end
    end

    mount V1::Articles
    mount V1::Users

    add_swagger_documentation \
      base_path: '/api'
  end
end
