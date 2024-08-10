class AddOutfitCodeNameToChoice < ActiveRecord::Migration[7.1]
  def change
    add_column :choices, :outfit_codename, :string
  end
end
