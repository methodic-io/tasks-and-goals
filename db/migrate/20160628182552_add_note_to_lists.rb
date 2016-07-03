# encoding: utf-8
# frozen_string_literal: true

class AddNoteToLists < ActiveRecord::Migration
  def change
    add_column :lists, :note, :text
  end
end
