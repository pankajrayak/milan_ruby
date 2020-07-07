class AddPlaceOfBirthCountryToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :place_of_birth_country, :string
  end
end
