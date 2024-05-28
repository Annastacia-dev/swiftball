class RenameIncludeMashupInQuestion < ActiveRecord::Migration[7.1]
  def change
    rename_column :questions, :include_mashup, :piano_mashup
    add_column :questions, :guitar_mashup, :boolean, default: false
  end
end
