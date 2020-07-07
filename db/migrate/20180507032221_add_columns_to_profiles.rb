class AddColumnsToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :state, :string
    add_column :profiles, :facebook, :string
    add_column :profiles, :instagram, :string
    add_column :profiles, :job_status, :string
    add_column :profiles, :mix_tradition, :string
    add_column :profiles, :partner_preferences, :string
    add_column :profiles, :vacation_place, :string
    add_column :profiles, :country, :string
    add_column :profiles, :member_relationship, :string
  end
end
