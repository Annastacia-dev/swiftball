class CreateJoinTableToursOpeners < ActiveRecord::Migration[6.0]
  def change
    create_join_table :tours, :openers, column_options: { type: :uuid } do |t|
      t.index :tour_id
      t.index :opener_id
    end
  end
end

