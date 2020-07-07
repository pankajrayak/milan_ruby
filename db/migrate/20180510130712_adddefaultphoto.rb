class Adddefaultphoto < ActiveRecord::Migration[5.1]
  def self.up
    change_column :profiles, :photo,:boolean, :default=> false
  end
  def self.down
    remove_column :profiles, :photo, :default=> false
  end
end
