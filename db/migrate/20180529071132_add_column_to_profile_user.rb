class AddColumnToProfileUser < ActiveRecord::Migration[5.1]
  def change
  add_column :users , :middle_name, :string
  add_column :profiles, :linkedin, :string
  add_column :users, :expiration_date, :datetime
  end
end
