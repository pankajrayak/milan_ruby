class AddCountryStateToDealBreaker < ActiveRecord::Migration[5.2]
  def change
    add_column :deal_breakers, :country, :boolean
    add_column :deal_breakers, :state, :boolean
  end
end
