class NotificationAddInterestId < ActiveRecord::Migration[5.1]
  def change
   add_reference :notifications, :interest, index: true
  end
end
