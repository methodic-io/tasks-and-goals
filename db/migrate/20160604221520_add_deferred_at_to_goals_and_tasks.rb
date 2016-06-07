# encoding: utf-8
# frozen_string_literal: true

class AddDeferredAtToGoalsAndTasks < ActiveRecord::Migration
  def change
    add_column :goals, :deferred_at, :text
    add_column :tasks, :deferred_at, :text
  end
end
