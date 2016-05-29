# encoding: utf-8
# frozen_string_literal: true

# A collection of Lists. The Group helps with the conceptual organisation
# of its Lists.
class Group < ActiveRecord::Base
  validates :position, numericality: { greater_than_or_equal_to: 0 }
end
