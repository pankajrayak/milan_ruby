class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.references :user, foreign_key: true
      t.string :notifiable_type
      t.string :action
      t.timestamps
    end
  end
end
