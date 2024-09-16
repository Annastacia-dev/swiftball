class CreateLeaderboards < ActiveRecord::Migration[7.1]
  def change
    create_table :leaderboards, id: :uuid do |t|
      t.references :creator, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end
  end
end
