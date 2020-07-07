class RemoveColumnsProfile < ActiveRecord::Migration[5.2]
  def change
    remove_column :profiles, :mix_tradition
    remove_column :profiles, :religion
    remove_column :profiles, :interest
    remove_column :profiles, :vacation_place
  end
end
