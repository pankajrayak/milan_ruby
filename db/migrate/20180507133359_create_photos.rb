class CreatePhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :photos do |t|
        t.bigint "user_id"
        t.string "photo_type"
        t.string "sequence"
        t.boolean "active", default: true
        t.string "url"
        t.string "photo"
        t.string "workflow_state", default: 'new'
        t.references :user, foreign_key: true
       
        t.timestamps
    end
  end
end
