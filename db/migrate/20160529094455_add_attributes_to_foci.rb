# encoding: utf-8
# frozen_string_literal: true

class AddAttributesToFoci < ActiveRecord::Migration
  def change
    add_column :foci, :label,    :string
    add_column :foci, :note,     :text
    add_column :foci, :position, :integer
  end
end
