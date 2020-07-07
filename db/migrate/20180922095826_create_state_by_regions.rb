class CreateStateByRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :state_by_regions do |t|
      t.string :state
      t.string :region
    end
  end
end
