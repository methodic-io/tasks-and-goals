# encoding: utf-8
# frozen_string_literal: true

class AddAttributesToLists < ActiveRecord::Migration
  def change
    add_column :lists, :label,    :string
    add_column :lists, :position, :integer
  end
end
