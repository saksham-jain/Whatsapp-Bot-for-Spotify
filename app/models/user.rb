class User < ApplicationRecord
  def access_token_expired?
    (Time.now - updated_at) > 3300
  end
end
