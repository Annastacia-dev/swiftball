class AddIncludeAlbumsToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :include_album, :boolean, default: false
  end
end
