class CreateFeedbackResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :feedback_responses, id: :uuid do |t|
      t.references :feedback, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.text :message
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
