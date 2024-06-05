class AddAbbreviationToAlbums < ActiveRecord::Migration[7.1]
  def change
    add_column :albums, :abbr, :string
  end
end
