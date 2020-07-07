class CreateWorkflowStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :workflow_statuses do |t|
      t.string :module
      t.string :state
      t.text :comment
      t.date :created_at
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
