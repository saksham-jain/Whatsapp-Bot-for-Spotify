class AddClientToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :client
  end
end
