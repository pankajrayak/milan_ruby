class DefaultRequest < ActiveRecord::Migration[5.2]
  def change
    change_column :requests, :created_at, :datetime,default: -> { "CURRENT_TIMESTAMP" }
    change_column :requests, :updated_at, :datetime, default: -> { "CURRENT_TIMESTAMP" }
  end
end
