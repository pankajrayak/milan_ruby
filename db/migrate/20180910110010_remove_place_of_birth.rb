class RemovePlaceOfBirth < ActiveRecord::Migration[5.2]
  def change
    remove_column :profiles, :place_of_birth
  end
end
