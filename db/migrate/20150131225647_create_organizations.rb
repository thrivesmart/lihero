class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, index: true
      t.string :permalink, index: true
      t.string :website
      t.references :creator, index: true

      t.timestamps null: false
    end
    add_foreign_key :organizations, :users, column: :creator_id, primary_key: :id
  end
end
