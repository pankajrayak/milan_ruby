class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.string :gender
      t.date :dob
      t.text :about_me
      t.string :interest
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
