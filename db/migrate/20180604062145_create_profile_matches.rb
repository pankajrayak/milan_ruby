class CreateProfileMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :profile_matches do |t|
      t.references :user, foreign_key: true
      t.integer :match_user_id 
      t.datetime :match_sent_on
     end
     add_foreign_key :profile_matches, :users, column: :match_user_id
  end
end
