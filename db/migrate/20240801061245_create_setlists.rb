class CreateSetlists < ActiveRecord::Migration[7.1]
  def change
    create_table :setlists, id: :uuid do |t|
      t.references :tour, foreign_key: true, type: :uuid
      t.string :league
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
