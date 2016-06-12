# encoding: utf-8
# frozen_string_literal: true

# A collection of Lists. The Group helps with the conceptual organisation
# of its Lists.
class Group < ActiveRecord::Base
  include Deletable

  validates :label,    presence:     true
  validates :position, numericality: { greater_than_or_equal_to: 0 }
  validates :position, numericality: { only_integer: true }

  has_many :groupings
  has_many :lists, through: :groupings

  serialize :list_positions, Array
end
