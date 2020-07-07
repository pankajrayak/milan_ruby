class AddFieldsTo < ActiveRecord::Migration[5.1]
  def change
    change_table(:profiles) do |t|
      t.column :diet, :string
      t.column :smoke, :string
      t.column :drink, :string
      t.column :is_manglik, :boolean
      t.column :time_of_birth, :time
      t.column :place_of_birth, :string
      t.column :sun_sign, :string
    end
  end
end
