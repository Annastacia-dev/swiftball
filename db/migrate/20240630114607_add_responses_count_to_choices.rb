class AddResponsesCountToChoices < ActiveRecord::Migration[7.1]
  def change
    add_column :choices, :responses_count, :integer, default: 0
  end
end
