# encoding: utf-8
# frozen_string_literal: true

class ChangeRepeatFrequencyToInteger < ActiveRecord::Migration
  def change
    change_column :tasks, :repeat_frequency, :integer
  end
end
