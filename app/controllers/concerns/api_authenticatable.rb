# The API-Token Authentication hook
module ApiAuthenticatable 
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  included do
    before_action :authenticate_user!
  end

  private

  attr_reader :current_user, :current_user_session

  def current_account
    current_user.account
  end

  def authenticate_user!
    # 1. Extract bearer token, assign current_user_session
    @current_user_session = authenticate_with_http_token do |token, _options|
      # 2. Calculate SHA-256 digest
      token_digest = UserSession.digest_token(token)
      # 3. Find active session
      UserSession.includes(user: :account).active.find_by(token_digest: token_digest)
    end

    # 4. Reject unauthorized requests
    return unauthorized! unless @current_user_session

    # 5. Assign current_user
    @current_user = @current_user_session.user
  end

  def unauthorized!
    response.headers["WWW-Authenticate"] = 'Bearer realm="api"'

    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end