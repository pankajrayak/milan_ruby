class ChangeProfileIsManglik < ActiveRecord::Migration[5.2]
  def change
    change_column :profiles, :is_manglik, :string
  end
end
