class AddIncludeSongToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :include_song, :boolean, default: true
  end
end
