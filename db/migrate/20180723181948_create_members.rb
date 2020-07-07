class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.boolean :Terms_accepted_on

      t.timestamps
    end
  end
end
