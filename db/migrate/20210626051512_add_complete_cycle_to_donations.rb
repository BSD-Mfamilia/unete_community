class AddCompleteCycleToDonations < ActiveRecord::Migration[6.1]
  def change
    add_column :donations, :complete_cycle, :boolean, null: false, default: false
  end
end
