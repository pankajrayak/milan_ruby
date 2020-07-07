class CreateJobstatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :jobstatuses do |t|
      t.string :name
      t.timestamps
    end
  end
end
