class CreateResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :responses, id: :uuid do |t|
      t.references :choice, null: false, foreign_key: true, type: :uuid
      t.references :attempt, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
