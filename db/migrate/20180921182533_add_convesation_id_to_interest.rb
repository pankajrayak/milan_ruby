class AddConvesationIdToInterest < ActiveRecord::Migration[5.2]
  def change
    add_column :interests, :conv_id, :integer
  end
end
