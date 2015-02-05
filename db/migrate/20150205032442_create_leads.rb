class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.references :list, index: true
      t.references :creator, index: true
      t.string :linkedinid, index: true
      t.string :kind, index: true
      t.timestamp :archived_at, index: true
      t.string :name, index: true
      t.string :email
      t.string :phone
      t.string :picurl
      t.text :details
      t.text :notes
      t.text :history

      t.timestamps null: false
    end
    add_foreign_key :leads, :lists
    add_foreign_key :leads, :users, column: :creator_id, primary_key: :id
  end
end
