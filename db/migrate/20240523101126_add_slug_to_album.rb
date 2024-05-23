class AddSlugToAlbum < ActiveRecord::Migration[7.1]
  def change
    add_column :albums, :slug, :string
  end
end
