class DropEndTimeFromTour < ActiveRecord::Migration[7.1]
  def change
    remove_column :tours, :end_time
  end
end
