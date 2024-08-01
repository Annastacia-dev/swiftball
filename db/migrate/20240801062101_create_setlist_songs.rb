class CreateSetlistSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :setlist_songs, id: :uuid do |t|
      t.references :setlist, null: false, foreign_key: true, type: :uuid
      t.references :song, null: false, foreign_key: true, type: :uuid
      t.integer :era, default: 0
      t.integer :length, default: 0

      t.timestamps
    end
  end
end
