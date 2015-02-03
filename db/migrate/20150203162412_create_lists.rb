class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.references :organization, index: true
      t.string :name, index: true
      t.string :permalink, index: true
      t.string :description
      t.string :picurl
      t.references :creator, index: true

      t.timestamps null: false
    end
    add_foreign_key :lists, :organizations
    add_foreign_key :lists, :users, column: :creator_id, primary_key: :id
    add_index :lists, [:organization_id, :permalink]
  end
end
