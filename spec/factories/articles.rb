# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    content { Faker::ChuckNorris.fact }
    cover { 'MyString' }
    public_date { '2020-04-06' }
    show { true }
  end
end
