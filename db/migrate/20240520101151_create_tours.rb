class CreateTours < ActiveRecord::Migration[7.1]
  def change
    create_table :tours, id: :uuid do |t|
      t.integer :number
      t.string :title
      t.date :date
      t.time :start_time
      t.time :end_time
      t.string :timezone

      t.timestamps
    end
  end
end
