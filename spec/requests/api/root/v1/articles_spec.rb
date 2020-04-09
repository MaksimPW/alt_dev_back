# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::Root::V1::Articles, type: :request do
  let(:result) { JSON.parse(response.body) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:headers) { auth_header(user) }
  let(:params) { nil }

  let(:articles) { create_list(:article, 2, user: user) }
  let(:hidden_articles) { create_list(:article, 3, user: user, show: false) }

  let(:other_articles) { create_list(:article, 2, user: other_user) }
  let(:other_hidden_articles) { create_list(:article, 1, user: other_user, show: false) }

  before do
    articles
    hidden_articles
    other_articles
    other_hidden_articles
  end

  describe '#index' do
    context 'with positive case' do
      context 'with author user' do
        context 'with all articles' do
          before do
            get '/api/v1/articles', params: params, headers: headers
          end

          it 'returns public articles' do
            expect(result.count).to eq 4
          end

          include_examples 'expect 200'
        end

        context 'with only author articles' do
          let(:params) { { 'mine': true } }

          before do
            get '/api/v1/articles', params: params, headers: headers
          end

          it 'returns mine articles' do
            expect(result.count).to eq 5
          end

          include_examples 'expect 200'
        end
      end

      context 'with other user' do
        let(:headers) { nil }

        context 'with all articles' do
          before do
            get '/api/v1/articles', params: params, headers: headers
          end

          it 'returns unhidden articles' do
            expect(result.count).to eq 4
          end

          include_examples 'expect 200'
        end

        context 'with only author articles' do
          let(:params) { { 'mine': true } }

          before do
            get '/api/v1/articles', params: params, headers: headers
          end

          include_examples 'expect 401'
        end
      end
    end
  end

  describe '#show' do
    context 'with positive case' do
      context 'with public article' do
        let(:article) { articles.first }
        let(:id) { article.id }

        before do
          get "/api/v1/articles/#{id}", params: params, headers: headers
        end

        context 'with author user' do
          include_examples 'expect 200'
        end

        context 'with other user' do
          let(:headers) { auth_header(other_user) }

          include_examples 'expect 200'
        end

        context 'with empty user' do
          let(:headers) { nil }

          include_examples 'expect 200'
        end
      end

      context 'with hidden article' do
        let(:article) { hidden_articles.first }
        let(:id) { article.id }

        before do
          get "/api/v1/articles/#{id}", params: params, headers: headers
        end

        context 'with author user' do
          include_examples 'expect 200'
        end

        context 'with other user' do
          let(:headers) { auth_header(other_user) }

          include_examples 'expect 403'
        end

        context 'with empty user' do
          let(:headers) { nil }

          include_examples 'expect 401'
        end
      end
    end

    context 'with negative case' do
      let(:id) { 'invalid_id' }

      before do
        get "/api/v1/articles/#{id}", params: params, headers: headers
      end

      context 'with user' do
        include_examples 'expect 404'
      end
    end
  end

  describe '#create' do
    context 'with positive case' do
      let(:params) do
        {
          title: 'Title',
          description: 'Description',
          content: 'Content'
        }
      end

      before do
        post '/api/v1/articles', params: params.to_json, headers: headers
      end

      context 'with user' do
        include_examples 'expect 201'
      end

      context 'with empty user' do
        let(:headers) { nil }

        include_examples 'expect 400'
      end
    end

    context 'with negative case' do
      let(:params) do
        {
          description: 'Description',
          content: 'Content'
        }
      end

      before do
        post '/api/v1/articles', params: params.to_json, headers: headers
      end

      context 'with user' do
        include_examples 'expect 400'
      end
    end
  end

  describe '#update' do
    context 'with positive case' do
      let(:article) { articles.first }
      let(:id) { article.id }
      let(:params) do
        {
          title: 'Changed Title'
        }
      end

      before do
        patch "/api/v1/articles/#{id}", params: params.to_json, headers: headers
      end

      context 'with user' do
        include_examples 'expect 200'
      end

      context 'with other user' do
        let(:headers) { auth_header(other_user) }

        include_examples 'expect 403'
      end

      context 'with empty user' do
        let(:headers) { nil }

        include_examples 'expect 401'
      end
    end
  end

  describe '#destroy' do
    context 'with positive case' do
      let(:article) { articles.first }
      let(:id) { article.id }

      before do
        delete "/api/v1/articles/#{id}", params: params, headers: headers
      end

      context 'with user' do
        include_examples 'expect 200'
      end

      context 'with other user' do
        let(:headers) { auth_header(other_user) }

        include_examples 'expect 403'
      end

      context 'with empty user' do
        let(:headers) { nil }

        include_examples 'expect 401'
      end
    end
  end
end
