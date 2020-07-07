class AddFiledPhotoForOn < ActiveRecord::Migration[5.1]
  def change
    add_column :photos , :photo_for, :string
  end
end
