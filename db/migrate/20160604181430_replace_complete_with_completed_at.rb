# encoding: utf-8
# frozen_string_literal: true

class ReplaceCompleteWithCompletedAt < ActiveRecord::Migration
  def change
    remove_column :goals,    :complete
    remove_column :subtasks, :complete
    remove_column :tasks,    :complete

    add_column :goals,    :completed_at, :datetime
    add_column :subtasks, :completed_at, :datetime
    add_column :tasks,    :completed_at, :datetime
  end
end
