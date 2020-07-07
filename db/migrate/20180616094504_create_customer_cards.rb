class CreateCustomerCards < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_cards do |t|
      t.string :customer_id
      t.string :customer_card
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
