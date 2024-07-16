class AddEraOrderToTour < ActiveRecord::Migration[7.1]
  def change
    add_column :tours, :era_order, :integer, default: 0
  end
end
