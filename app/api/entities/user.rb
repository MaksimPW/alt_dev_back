# frozen_string_literal: true

module Entities
  class User < Grape::Entity
    format_with(:iso_timestamp, &:iso8601)

    expose :id
    expose :email

    with_options(format_with: :iso_timestamp) do
      expose :created_at
      expose :updated_at
    end
  end
end
