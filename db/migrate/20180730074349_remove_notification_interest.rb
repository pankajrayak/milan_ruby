class RemoveNotificationInterest < ActiveRecord::Migration[5.2]
  def change
    remove_column :notifications, :interest_id
    
  end
end
