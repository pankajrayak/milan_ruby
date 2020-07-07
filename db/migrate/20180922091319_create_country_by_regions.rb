class CreateCountryByRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :country_by_regions do |t|
      t.string :country
      t.string :region
    end
  end
end
