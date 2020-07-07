class RegionInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :users , :region , 'integer USING CAST(region AS integer)'
  end
end
