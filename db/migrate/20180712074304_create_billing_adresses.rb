class CreateBillingAdresses < ActiveRecord::Migration[5.2]
  def change
    create_table :billing_adresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :address_line_one
      t.string :address_two_one
      t.string :city
      t.integer :zipcode
      t.integer :phone
      t.string :email
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
