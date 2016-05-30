# encoding: utf-8
# frozen_string_literal: true

class AddAttributesToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :label,    :string
    add_column :groups, :open,     :boolean, default: false
    add_column :groups, :position, :integer
  end
end
