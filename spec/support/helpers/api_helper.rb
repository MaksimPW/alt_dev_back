# frozen_string_literal: true

module AcceptanceHelper
  def auth_header(user)
    token = JsonWebToken.encode(user_id: user.id)

    { 'Authorization': "Bearer #{token}",
      'Content-Type': 'application/json' }
  end
end
