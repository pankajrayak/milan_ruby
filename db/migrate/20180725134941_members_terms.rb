class MembersTerms < ActiveRecord::Migration[5.2]
  def change
    rename_column :members, :Terms_accepted_on ,:terms_accepted_on
    rename_column :members, :users_id, :user_id
  end
end
