class AddContinentToRegion < ActiveRecord::Migration[5.2]
  def change
    add_column :regions, :continent, :string
  end
end
