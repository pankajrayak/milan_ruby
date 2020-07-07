class BillingAddressRename < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :billing_adresses, :billing_addresses
    change_column :billing_addresses, :phone, :string
    change_column :billing_addresses, :zipcode, :string
  end

  def self.down
    rename_table :billing_adresses, :billing_adresses
  end
end
