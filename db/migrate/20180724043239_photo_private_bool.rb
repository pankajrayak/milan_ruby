class PhotoPrivateBool < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :private, :boolean , :default=> false
  end
end
