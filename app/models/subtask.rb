# encoding: utf-8
# frozen_string_literal: true

# An individual step, the combination of which make up the activity of a Task.
class Subtask < ActiveRecord::Base
  validates :label,    presence:     true
  validates :position, numericality: { greater_than_or_equal_to: 0 }
end
