class AddIsAMashupQuestionToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :include_mashup, :boolean, default: false
    add_column :questions, :include_album_and_song, :boolean, default: false
    remove_column :questions, :include_song
    remove_column :questions, :include_album
  end
end
