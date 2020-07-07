class AddColumnsToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :export_data, :boolean, :default=>false
    add_column :members, :export_request_on, :datetime
    add_column :members, :export_accepted_on, :datetime
    #add_column :members, :file_path, :string
  end
end
