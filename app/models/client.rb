class Client < ApplicationRecord
  has_one :user, dependent: :destroy
end
