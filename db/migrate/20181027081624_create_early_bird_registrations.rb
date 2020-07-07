class CreateEarlyBirdRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :early_bird_registrations do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :email

      t.timestamps
    end
  end
end
