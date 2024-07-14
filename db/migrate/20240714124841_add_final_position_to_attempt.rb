class AddFinalPositionToAttempt < ActiveRecord::Migration[7.1]
  def change
    add_column :attempts, :final_position, :integer
  end
end
