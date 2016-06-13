# encoding: utf-8
# frozen_string_literal: true

# A collection of Lists. The Group helps with the conceptual organisation
# of its Lists.
class Group < ActiveRecord::Base
  include Deletable
  include Positionable

  validates :label, presence: true

  has_many :groupings
  has_many :lists, through: :groupings

  serialize :list_positions, Array
end
