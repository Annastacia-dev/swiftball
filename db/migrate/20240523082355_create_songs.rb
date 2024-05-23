class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs, id: :uuid do |t|
      t.references :album, null: false, foreign_key: true, type: :uuid
      t.string :title

      t.timestamps
    end
  end
end
