class Mention < ApplicationRecord
  SOURCES = %w[news blog social_media]

  belongs_to :account

  validates :title, :url, :source_type, presence: true
  validates :source_type, inclusion: { in: SOURCES }
  validates :url, url: true
end
