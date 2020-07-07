class Addphotodeletepicture < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :picture
    add_column :profiles, :photo, :boolean
  end
end
