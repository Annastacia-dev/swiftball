class AddLabelToChoice < ActiveRecord::Migration[7.1]
  def change
    add_column :choices, :label, :integer, default: 0
  end
end
