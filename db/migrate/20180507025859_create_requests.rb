class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.bigint :initiated_by
      t.bigint :approved_by
      t.date :created_at
      t.date :updated_at
      t.string :status
      t.string :type
      t.text :comment
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
