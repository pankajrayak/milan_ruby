class AddReligionToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :religion, :string
  end
end
