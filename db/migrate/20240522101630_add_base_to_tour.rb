class AddBaseToTour < ActiveRecord::Migration[7.1]
  def change
    add_column :tours, :base, :boolean, default: false
  end
end
