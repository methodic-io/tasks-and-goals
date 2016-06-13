# encoding: utf-8
# frozen_string_literal: true

# The core conceptual interest that describes a Goal.
class Focus < ActiveRecord::Base
  include Deletable
  include Positionable

  self.table_name = 'foci'

  validates :label, presence: true

  has_many :goals
end
