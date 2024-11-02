class AddFinalScoreToAttempt < ActiveRecord::Migration[7.2]
  def change
    add_column :attempts, :final_score, :integer
  end
end
