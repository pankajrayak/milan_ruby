class AddCountryStateToBillingAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :billing_addresses, :country, :string
    add_column :billing_addresses, :state, :string
  end
end
