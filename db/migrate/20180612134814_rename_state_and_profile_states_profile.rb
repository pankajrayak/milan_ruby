class RenameStateAndProfileStatesProfile < ActiveRecord::Migration[5.1]
  def change
    rename_column :profiles, :state, :profile_state
    rename_column :profiles, :states, :state
  end
end
