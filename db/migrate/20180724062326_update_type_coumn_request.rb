class UpdateTypeCoumnRequest < ActiveRecord::Migration[5.2]
  def change
    rename_column :requests, :type, :module
  end
end
