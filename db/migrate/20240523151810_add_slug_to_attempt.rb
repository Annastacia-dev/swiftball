class AddSlugToAttempt < ActiveRecord::Migration[7.1]
  def change
    add_column :attempts, :slug, :string
  end
end
