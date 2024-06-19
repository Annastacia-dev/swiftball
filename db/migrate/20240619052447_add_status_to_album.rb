class AddStatusToAlbum < ActiveRecord::Migration[7.1]
  def change
    add_column :albums, :status, :integer, default: 0
  end
end
