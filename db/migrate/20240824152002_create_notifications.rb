class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications, id: :uuid do |t|
      t.string :subject
      t.text :message
      t.string :link
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :status, default: 0
      t.boolean :email_only, default: false
      t.boolean :push_only, default: false

      t.timestamps
    end
  end
end
