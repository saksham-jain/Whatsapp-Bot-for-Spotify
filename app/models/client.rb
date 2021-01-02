class Client < ApplicationRecord
  has_one :user, dependent: :destroy
  validates :client_id, uniqueness: true
end
