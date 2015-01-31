class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :email, index: true
      t.string :picurl
      t.string :googleid
      t.string :facebookid
      t.string :twitterid
      t.string :linkedinid, index: true
      t.string :githubid
      t.boolean :superuser, index: true

      t.timestamps null: false
    end
  end
end
