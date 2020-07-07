class CreateCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :charges do |t|
      t.decimal :amount
      t.date :created_at
      t.string :state
      t.string :charge_id
      t.date :update_at
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
