class AddRequestTimestamp < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :requests, :created_at
    remove_column  :requests, :updated_at
    change_table :requests do |t|
      t.timestamps
  end
  end

  def self.down
    remove_column :requests, :created_at
    remove_column  :requests, :updated_at
  
  end    
end
