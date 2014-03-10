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

ActiveRecord::Schema.define(version: 20140206200006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "handle",      default: "",    null: false
    t.string   "description"
    t.integer  "user_id",                     null: false
    t.boolean  "technician",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["handle"], name: "index_accounts_on_handle", unique: true, using: :btree
  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "name",        default: "", null: false
    t.string   "description", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.string   "comment",          default: "", null: false
    t.integer  "account_id",                    null: false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["account_id"], name: "index_comments_on_account_id", using: :btree
  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name",        default: "", null: false
    t.string   "code",        default: "", null: false
    t.text     "description", default: "", null: false
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["admin_id"], name: "index_groups_on_admin_id", using: :btree
  add_index "groups", ["code"], name: "index_groups_on_code", unique: true, using: :btree
  add_index "groups", ["name"], name: "index_groups_on_name", unique: true, using: :btree

  create_table "issue_categories", force: true do |t|
    t.integer  "issue_id",    null: false
    t.integer  "category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issue_categories", ["category_id"], name: "index_issue_categories_on_category_id", using: :btree
  add_index "issue_categories", ["issue_id"], name: "index_issue_categories_on_issue_id", using: :btree

  create_table "issues", force: true do |t|
    t.string   "subject",     default: "", null: false
    t.text     "description", default: "", null: false
    t.integer  "account_id",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issues", ["account_id"], name: "index_issues_on_account_id", using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "account_id", null: false
    t.integer  "group_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["account_id"], name: "index_memberships_on_account_id", using: :btree
  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree

  create_table "solutions", force: true do |t|
    t.text     "solution",   default: "",    null: false
    t.boolean  "accepted",   default: false
    t.integer  "issue_id",                   null: false
    t.integer  "account_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "solutions", ["account_id"], name: "index_solutions_on_account_id", using: :btree
  add_index "solutions", ["issue_id"], name: "index_solutions_on_issue_id", using: :btree

  create_table "technicians", force: true do |t|
    t.integer  "account_id", null: false
    t.integer  "group_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "technicians", ["account_id"], name: "index_technicians_on_account_id", using: :btree
  add_index "technicians", ["group_id"], name: "index_technicians_on_group_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",         default: "", null: false
    t.string   "last_name",          default: "", null: false
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
