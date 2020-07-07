class ChangeProfileTimeOfBirth < ActiveRecord::Migration[5.2]
  def change
    change_column :profiles, :time_of_birth, :string
  end
end
