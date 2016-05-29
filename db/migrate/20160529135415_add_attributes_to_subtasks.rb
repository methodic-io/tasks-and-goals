# encoding: utf-8
# frozen_string_literal: true

class AddAttributesToSubtasks < ActiveRecord::Migration
  def change
    add_column :subtasks, :label,    :string
    add_column :subtasks, :position, :integer
    add_column :subtasks, :complete, :boolean, default: false
  end
end
