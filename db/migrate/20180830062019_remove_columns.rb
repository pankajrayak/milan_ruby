class RemoveColumns < ActiveRecord::Migration[5.2]
  
  def change
    unless !column_exists? :interests, :conversation_id
    remove_column :interests, :conversation_id
    end
    remove_column :profiles, :job_status
    remove_column :profiles, :sun_sign
    unless !table_exists? :job_statuses
      drop_table :job_statuses
    end
    unless !column_exists? :interests, :sent_on
      remove_column :interests, :sent_on
    end
  end

end
