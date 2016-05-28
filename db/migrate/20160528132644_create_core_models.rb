# encoding: utf-8
# frozen_string_literal: true

# Migration that creates the 6 core models and adds the core date
# attributes to each.
class CreateCoreModels < ActiveRecord::Migration
  def change
    [:foci, :goals, :groups, :lists, :subtasks, :tasks].each do |table|
      create_table table do |t|
        t.timestamps
        t.datetime :deleted_at
      end
    end
  end
end
