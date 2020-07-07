class Profilefields < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles , :values, :string
    add_column :profiles, :country_raised, :string
  end
end
