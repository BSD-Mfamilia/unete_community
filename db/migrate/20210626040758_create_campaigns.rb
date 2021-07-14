class CreateCampaigns < ActiveRecord::Migration[6.1]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :description
      t.boolean :status, null: false, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
