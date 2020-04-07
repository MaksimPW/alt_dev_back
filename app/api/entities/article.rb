# frozen_string_literal: true

module Entities
  class Article < Grape::Entity
    format_with(:iso_timestamp, &:iso8601)

    expose :id
    expose :title
    expose :description
    expose :cover
    expose :content
    expose :public_date
    expose :user_id
    expose :hidden

    with_options(format_with: :iso_timestamp) do
      expose :created_at
      expose :updated_at
    end
  end
end
