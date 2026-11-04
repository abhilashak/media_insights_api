## Authentication controller
#
# Test login
# curl -i -X POST http://localhost:3000/api/v1/session \
#   -H "Content-Type: application/json" \
#   -d '{
#     "session": {
#       "email": User.first.email,
#       "password": User.first.password
#     }
#   }'
#
# Test Auth endpoint
# curl -i http://localhost:3000/api/v1/session/test \
# -H "Authorization: Bearer YOUR_RAW_TOKEN"
#
# Test session delete
# curl -i -X DELETE http://localhost:3000/api/v1/session \
#   -H "Authorization: Bearer YOUR_RAW_TOKEN"
# 
class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: :create

  def create
    credentials = session_params

    user = User.find_by(email: credentials[:email])

    authenticate = user&.authenticate(credentials[:password])

    unless authenticate
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end

    user_session = UserSession.generate_for(user)

    render json: {
          token: user_session.token,
          token_type: "Bearer",
          expires_at: user_session.expires_at,
          user: {
            id: user.id,
            name: user.name,
            email: user.email
          },
          account: {
            id: user.account.id,
            name: user.account.name
          }
        }, status: :created
  end

  def destroy
    current_user_session.update!(revoked_at: Time.current)

    head :no_content
  end

  def test
    render json: { success: true }
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end