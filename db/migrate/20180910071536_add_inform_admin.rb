class AddInformAdmin < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :inform_admin, :boolean, :default=> true
  end
end
