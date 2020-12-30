class User < ApplicationRecord
  belongs_to :client
  
  def access_token_expired?
    (Time.now - updated_at) > 3300
  end
end
