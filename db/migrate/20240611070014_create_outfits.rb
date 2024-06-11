class CreateOutfits < ActiveRecord::Migration[7.1]
  def change
    create_table :outfits, id: :uuid do |t|
      t.integer :era

      t.timestamps
    end
  end
end
