class AddColumnsToProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :marital_status, :string
    add_column :profiles, :community, :string
    add_column :profiles, :education_level, :string
    add_column :profiles, :have_children, :string
    add_column :profiles, :states, :string
    add_column :profiles, :city, :string
    add_column :profiles, :height, :integer
  end
end
