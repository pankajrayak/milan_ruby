class CreateOccupations < ActiveRecord::Migration[5.2]
  def change
    create_table :occupations do |t|
      t.string :title
      t.string :name

      t.timestamps
    end
  end
end
