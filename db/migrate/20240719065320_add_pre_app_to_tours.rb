class AddPreAppToTours < ActiveRecord::Migration[7.1]
  def change
    add_column :tours, :preapp, :boolean, default: false
  end
end
