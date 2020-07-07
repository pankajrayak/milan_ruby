class CreateMemberRelation < ActiveRecord::Migration[5.2]
  def change
    add_reference :members, :users
  end
end
