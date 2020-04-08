# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::Root::V1::Users, type: :request do
  let(:user) { create(:user, email: email, password: password) }
  let(:email) { 'example@example.org' }
  let(:password) { '12345678' }
  let(:params) do
    {
      email: email,
      password: password
    }
  end
  let(:headers) { auth_header(user) }

  before do
    user
  end

  describe '#sign_in' do
    context 'with positive case' do
      before do
        post '/api/v1/users/sign_in', params: params
      end

      include_examples 'expect 200'
    end

    context 'with negative case' do
      let(:params) do
        {
          email: email,
          password: 'bad_pass'
        }
      end

      before do
        post '/api/v1/users/sign_in', params: params
      end

      include_examples 'expect 401'
    end
  end

  describe '#current' do
    context 'with positive case' do
      before do
        get '/api/v1/users/current', headers: headers
      end

      include_examples 'expect 200'
    end

    context 'with negative case' do
      let(:headers) {}

      before do
        get '/api/v1/users/current', headers: headers
      end

      include_examples 'expect 401'
    end
  end
end
