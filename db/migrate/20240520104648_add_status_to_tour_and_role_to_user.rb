class AddStatusToTourAndRoleToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :tours, :status, :integer, default: 0
    add_column :users, :role, :integer, default: 0
  end
end
