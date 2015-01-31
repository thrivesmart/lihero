# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150131230004) do

  create_table "org_user_privileges", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.string   "privileges"
    t.integer  "creator_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "org_user_privileges", ["creator_id"], name: "index_org_user_privileges_on_creator_id"
  add_index "org_user_privileges", ["organization_id", "privileges"], name: "index_org_user_privileges_on_organization_id_and_privileges"
  add_index "org_user_privileges", ["organization_id"], name: "index_org_user_privileges_on_organization_id"
  add_index "org_user_privileges", ["privileges"], name: "index_org_user_privileges_on_privileges"
  add_index "org_user_privileges", ["user_id", "privileges"], name: "index_org_user_privileges_on_user_id_and_privileges"
  add_index "org_user_privileges", ["user_id"], name: "index_org_user_privileges_on_user_id"

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "permalink"
    t.string   "website"
    t.integer  "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "organizations", ["creator_id"], name: "index_organizations_on_creator_id"
  add_index "organizations", ["name"], name: "index_organizations_on_name"
  add_index "organizations", ["permalink"], name: "index_organizations_on_permalink"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "picurl"
    t.string   "googleid"
    t.string   "facebookid"
    t.string   "twitterid"
    t.string   "linkedinid"
    t.string   "githubid"
    t.boolean  "superuser"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["linkedinid"], name: "index_users_on_linkedinid"
  add_index "users", ["superuser"], name: "index_users_on_superuser"

end
