class RemoveExportDataFromMember < ActiveRecord::Migration[5.2]
  def change
    remove_column :members, :export_data, :boolean
  end
end
