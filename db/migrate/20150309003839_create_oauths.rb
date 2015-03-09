class CreateOauths < ActiveRecord::Migration
  def change
    create_table :oauths do |t|
      t.references :user, index: true
      t.string :account
      t.string :kind
      t.string :token
      t.string :secret

      t.timestamps null: false
    end
    add_foreign_key :oauths, :users
  end
end
