class CreateOrgUserPrivileges < ActiveRecord::Migration
  def change
    create_table :org_user_privileges do |t|
      t.references :organization, index: true
      t.references :user, index: true
      t.string :privileges, index: true
      t.references :creator, index: true

      t.timestamps null: false
    end
    add_foreign_key :org_user_privileges, :organizations
    add_foreign_key :org_user_privileges, :users
    add_foreign_key :org_user_privileges, :creators
    add_index :org_user_privileges, [:user_id, :privileges]
    add_index :org_user_privileges, [:organization_id, :privileges]
  end
end
