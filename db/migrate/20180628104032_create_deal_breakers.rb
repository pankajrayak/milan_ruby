class CreateDealBreakers < ActiveRecord::Migration[5.2]
  def change
    create_table :deal_breakers do |t|
      t.boolean :age
      t.boolean :height
      t.boolean :marital_status
      t.boolean :have_children
      t.boolean :religion
      t.boolean :community
      t.references :partner_preference, foreign_key: true
      t.timestamps
    end
  end
end
