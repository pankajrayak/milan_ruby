class UpatePhotosPrivateToPrivatePic < ActiveRecord::Migration[5.2]
  def self.up
    rename_column :photos, :private, :private_pic
  end

  def self.down
    rename_column :photos, :private_pic, :private
    # rename back if you need or do something else or do nothing
  end
end
