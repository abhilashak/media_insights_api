class UserSession < ApplicationRecord
  attr_accessor :token

  belongs_to :user

  validates :token_digest, presence: true, uniqueness: true
  validates :expires_at, presence: true

  scope :active, -> { 
    where(revoked_at: nil).
    where("expires_at > ?", Time.current) 
  }

  def self.digest_token(token)
    Digest::SHA256.hexdigest(token)
  end

  def self.generate_for(user)
    token = SecureRandom.hex(32)

    session = user.user_sessions.build(
      token_digest: digest_token(token),
      expires_at: 24.hours.from_now
    )

    session.token = token
    session.save!

    session
  end
end
