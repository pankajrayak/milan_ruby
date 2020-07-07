class AddConversationIdToInterest < ActiveRecord::Migration[5.1]
  def change
    add_column :interests , :conversation_id, :integer
  end
end
