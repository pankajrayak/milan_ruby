class CreateInterests < ActiveRecord::Migration[5.1]
  def change
    create_table :interests do |t|
      t.integer :user_to
      t.date :sent_on
      t.date :updated_on
      t.string :state
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
