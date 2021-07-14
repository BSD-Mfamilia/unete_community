class AddSponsorToDonations < ActiveRecord::Migration[6.1]
  def change
    add_column :donations, :sponsor, :boolean, null: false, default: false
  end
end
