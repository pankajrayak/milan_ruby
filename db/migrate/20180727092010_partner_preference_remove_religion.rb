class PartnerPreferenceRemoveReligion < ActiveRecord::Migration[5.2]
  def change
    remove_column :partner_preferences, :religion
  end
end
