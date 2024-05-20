class CreateChoices < ActiveRecord::Migration[7.1]
  def change
    create_table :choices, id: :uuid do |t|
      t.references :question, null: false, foreign_key: true, type: :uuid
      t.string :content
      t.boolean :correct, default: false

      t.timestamps
    end
  end
end
