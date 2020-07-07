class AddCountryStateToPartnerPreference < ActiveRecord::Migration[5.2]
  def change
    add_column :partner_preferences, :country, :string
    add_column :partner_preferences, :state, :string
  end
end
