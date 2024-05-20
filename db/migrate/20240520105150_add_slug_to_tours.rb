class AddSlugToTours < ActiveRecord::Migration[7.1]
  def change
    add_column :tours, :slug, :string
  end
end
