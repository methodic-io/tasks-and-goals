# encoding: utf-8
# frozen_string_literal: true

# A collection of Tasks. The List helps with the conceptual organisation
# of its Tasks.
class List < ActiveRecord::Base
  validates :label,    presence:     true

  belongs_to :goal
  has_many   :groupings
  has_many   :groups, through: :groupings
  has_many   :listings
  has_many   :tasks, through: :listings

  serialize :task_positions, Array
end
