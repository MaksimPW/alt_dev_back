# frozen_string_literal: true

class Article < ApplicationRecord
  after_initialize :set_date

  validates :title, presence: true
  validates :content, presence: true

  belongs_to :user

  mount_uploader :cover, ImageUploader

  def set_date
    self.public_date ||= Date.current
  end
end
