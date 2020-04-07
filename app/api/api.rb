# frozen_string_literal: true

module API
  class Root < Grape::API
    prefix 'api'
    format :json

    mount V1::Root
  end
end
