# frozen_string_literal: true

class Article < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  belongs_to :user

  mount_uploader :cover, ImageUploader
end
