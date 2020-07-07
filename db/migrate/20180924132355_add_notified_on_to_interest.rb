class AddNotifiedOnToInterest < ActiveRecord::Migration[5.2]
  def change
    add_column :interests, :notified_on, :datetime
  end
end
