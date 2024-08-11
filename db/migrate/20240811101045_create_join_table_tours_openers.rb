class CreateJoinTableToursOpeners < ActiveRecord::Migration[7.1]
  def change
    create_join_table :tours, :openers do |t|
      t.index :tour_id
      t.index :opener_id
    end
  end
end
