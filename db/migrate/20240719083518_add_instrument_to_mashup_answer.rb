class AddInstrumentToMashupAnswer < ActiveRecord::Migration[7.1]
  def change
    add_column :mashup_answers, :instrument, :integer, default: 0
    add_column :mashup_answers, :guest, :string
  end
end
