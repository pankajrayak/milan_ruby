class StateofbirthinProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :state_of_birth, :string
    rename_column :profiles, :place_of_birth_country, :country_of_birth
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
