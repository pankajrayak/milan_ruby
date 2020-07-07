class AddOccupationEducationConcentrationIncomeToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :income, :string
    add_column :profiles, :occupation, :string
    add_column :profiles, :education_concentration, :string
  end
end
