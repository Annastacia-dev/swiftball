class CreateAttempts < ActiveRecord::Migration[7.1]
  def change
    create_table :attempts, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :quiz, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
