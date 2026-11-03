class User < ApplicationRecord
  belongs_to :account
  has_many :user_sessions, dependent: :destroy
  
  has_secure_password

  normalizes :email, with: -> (email) { email.strip.downcase }

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "is an invalid email format" }
end
