class UsersSetRegionString < ActiveRecord::Migration[5.2]
  def change
    change_column :users , :region, :string
  end
end
