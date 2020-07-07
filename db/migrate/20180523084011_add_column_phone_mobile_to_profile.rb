class AddColumnPhoneMobileToProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :mobile_number, :string
    add_column :profiles, :phone_number, :string
  end
end
