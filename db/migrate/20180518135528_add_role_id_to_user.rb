class AddRoleIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :role
  end
end
