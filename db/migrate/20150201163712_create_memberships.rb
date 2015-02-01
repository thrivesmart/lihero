class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :organization, index: true
      t.references :user, index: true
      t.string :privileges, index: true
      t.references :creator, index: true

      t.timestamps null: false
    end
    add_foreign_key :memberships, :organizations
    add_foreign_key :memberships, :users
    add_foreign_key :memberships, :users, column: :creator_id, primary_key: :id
    add_index :memberships, [:user_id, :privileges]
    add_index :memberships, [:organization_id, :privileges]
  end
end
