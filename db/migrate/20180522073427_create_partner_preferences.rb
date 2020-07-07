class CreatePartnerPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :partner_preferences do |t|
      t.integer :age_from
      t.integer :age_to
      t.integer :height_from
      t.integer :height_to
      t.string :marital_status
      t.string :have_children
      t.string :religion
      t.string :community
      t.references :user
      t.timestamps
    end
  end
end
