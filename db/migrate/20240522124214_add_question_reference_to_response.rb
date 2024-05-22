class AddQuestionReferenceToResponse < ActiveRecord::Migration[7.1]
  def change
    add_reference :responses, :question, null: false, foreign_key: true, type: :uuid
  end
end
