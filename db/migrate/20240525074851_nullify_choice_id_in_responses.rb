class NullifyChoiceIdInResponses < ActiveRecord::Migration[7.1]
  def change
    change_column_null :responses, :choice_id, true
  end
end
