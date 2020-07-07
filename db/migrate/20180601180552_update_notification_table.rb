class UpdateNotificationTable < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :message , :string
    remove_column :notifications , :notifiable_id
    remove_column :notifications, :notifiable_type 
  end
end
