class User < ApplicationRecord
  belongs_to :account
  
  normalizes :email, with: -> (email) { email.strip.downcase }

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "is an invalid email format" }
end
