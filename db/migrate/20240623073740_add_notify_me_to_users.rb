class AddNotifyMeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :notify_me, :boolean, default: true
  end
end
