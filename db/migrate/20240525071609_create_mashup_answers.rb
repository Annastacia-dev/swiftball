class CreateMashupAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :mashup_answers, id: :uuid do |t|
      t.references :question, null: false, foreign_key: true, type: :uuid
      t.references :attempt, foreign_key: true, type: :uuid
      t.boolean :correct, default: false
      t.references :album, null: false, foreign_key: true, type: :uuid
      t.references :song, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
