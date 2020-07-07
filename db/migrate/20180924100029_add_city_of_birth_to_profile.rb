class AddCityOfBirthToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :city_of_birth, :string
  end
end
