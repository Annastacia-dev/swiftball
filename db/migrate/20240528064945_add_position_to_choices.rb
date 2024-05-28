class AddPositionToChoices < ActiveRecord::Migration[7.1]
  def change
    add_column :choices, :position, :integer
    add_column :choices, :new_item, :boolean, default: false
  end
end
