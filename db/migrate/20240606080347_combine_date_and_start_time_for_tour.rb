class CombineDateAndStartTimeForTour < ActiveRecord::Migration[7.1]
  def up
    remove_column :tours, :date, :date
    remove_column :tours, :start_time, :time
    add_column :tours, :combined_datetime, :datetime
    rename_column :tours, :combined_datetime, :start_time
  end

  def down
    add_column :tours, :date, :date
    add_column :tours, :start_time, :time
    remove_column :tours, :combined_datetime, :datetime
  end
end
