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

ActiveRecord::Schema.define(version: 20160605120417) do

  create_table "foci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "label"
    t.text     "note"
    t.integer  "position"
  end

  create_table "goals", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "label"
    t.text     "note"
    t.integer  "position"
    t.datetime "due_at"
    t.boolean  "specific",     default: false
    t.boolean  "measurable",   default: false
    t.boolean  "attainable",   default: false
    t.boolean  "relevant",     default: false
    t.boolean  "timely",       default: false
    t.integer  "difficulty",   default: 0
    t.integer  "importance",   default: 0
    t.integer  "urgency",      default: 0
    t.integer  "focus_id"
    t.datetime "completed_at"
    t.text     "deferred_at"
  end

  create_table "groupings", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groupings", ["group_id"], name: "index_groupings_on_group_id"
  add_index "groupings", ["list_id"], name: "index_groupings_on_list_id"

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "label"
    t.boolean  "open",           default: false
    t.integer  "position"
    t.text     "list_positions"
  end

  create_table "listings", force: :cascade do |t|
    t.integer  "list_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listings", ["list_id"], name: "index_listings_on_list_id"
  add_index "listings", ["task_id"], name: "index_listings_on_task_id"

  create_table "lists", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "label"
    t.integer  "goal_id"
    t.text     "task_positions"
  end

  create_table "subtasks", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "label"
    t.integer  "task_id"
    t.datetime "completed_at"
  end

  create_table "tasks", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "label"
    t.text     "note"
    t.datetime "due_at"
    t.datetime "reminder_at"
    t.string   "repeat_frequency"
    t.integer  "difficulty",        default: 0
    t.integer  "importance",        default: 0
    t.integer  "urgency",           default: 0
    t.datetime "completed_at"
    t.text     "deferred_at"
    t.text     "subtask_positions"
  end

end
