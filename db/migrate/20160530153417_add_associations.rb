# encoding: utf-8
# frozen_string_literal: true

class AddAssociations < ActiveRecord::Migration
  def change
    create_table :groupings do |t|
      t.belongs_to :group, index: true
      t.belongs_to :list,  index: true
      t.timestamps
    end

    create_table :listings do |t|
      t.belongs_to :list,  index: true
      t.belongs_to :task,  index: true
      t.timestamps
    end

    add_column :goals,    :focus_id, :integer
    add_column :lists,    :goal_id,  :integer
    add_column :subtasks, :task_id,  :integer
  end
end
