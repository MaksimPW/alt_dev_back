# frozen_string_literal: true

module V1
  class Articles < Grape::API
    # rubocop:disable Metrics/BlockLength
    namespace :articles do
      # GET /api/v1/articles/:id
      desc 'Returns an article by id'
      params do
        requires :id, type: String
      end
      get ':id' do
        @article = Article.where(id: declared(params)[:id]).first
        error!('Not found', 404) unless @article
        error!('Forbidden', 403) if !@article.show && @article.user_id != current_user.id

        present @article, with: Entities::Article
      end

      # GET /api/v1/articles
      desc 'Returns all articles'
      get do
        articles = if params[:mine]
                     Article.where(user: current_user)
                   else
                     Article.where(show: true)
                   end

        present articles, with: Entities::Article
      end

      # POST /api/v1/articles
      desc 'Create article'
      params do
        requires :title, type: String
        optional :description, type: String
        optional :cover, type: Rack::Multipart::UploadedFile
        requires :content, type: String
        optional :public_date, type: Date
        optional :show, type: Boolean
      end
      post do
        authenticate!

        @article = Article.new(params)
        @article.user = current_user
        @article.save
        present @article, with: Entities::Article
      end

      # PATCH /api/v1/articles/:id
      desc 'Update article'
      params do
        requires :id, type: String
        optional :title, type: String
        optional :description, type: String
        optional :content, type: String
        optional :public_date, type: Date
        optional :show, type: Boolean
      end
      patch ':id' do
        authenticate!

        @article = Article.find(params[:id])
        error!('Forbidden', 403) unless @article.user_id == current_user.id

        @article.update(params)
        present @article, with: Entities::Article
      end

      # DELETE /api/v1/articles/:id
      desc 'Delete article'
      params do
        requires :id, type: String
      end
      delete ':id' do
        authenticate!

        @article = Article.find(params[:id])
        error!('Forbidden', 403) unless @article.user_id == current_user.id

        @article.destroy!
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
