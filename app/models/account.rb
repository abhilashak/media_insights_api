class Account < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :mentions, dependent: :restrict_with_error

  validates :name, presence: true
end
