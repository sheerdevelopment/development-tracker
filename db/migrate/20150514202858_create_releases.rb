class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :jira_number
      t.integer :environment_id
      t.integer :status_id
      t.string :qa
      t.string :description

      t.timestamps null: false
    end
  end
end