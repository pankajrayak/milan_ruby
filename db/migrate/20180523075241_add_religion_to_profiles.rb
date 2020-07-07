class AddReligionToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :religion, :string
  end
end
