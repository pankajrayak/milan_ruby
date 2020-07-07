class HeightToFloatPartnerAndProfile < ActiveRecord::Migration[5.1]
  def change
    change_column :profiles, :height, :float
    change_column :partner_preferences, :height_from, :float
    change_column :partner_preferences, :height_to, :float
  end
end
