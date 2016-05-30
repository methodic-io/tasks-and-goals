# encoding: utf-8
# frozen_string_literal: true

# The core conceptual interest that describes a Goal.
class Focus < ActiveRecord::Base
  self.table_name = 'foci'

  validates :label,    presence:     true
  validates :position, numericality: { greater_than_or_equal_to: 0 }
end
