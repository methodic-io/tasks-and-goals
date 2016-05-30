# encoding: utf-8
# frozen_string_literal: true

# A collection of Tasks. The List helps with the conceptual organisation
# of its Tasks.
class List < ActiveRecord::Base
  validates :label,    presence:     true
  validates :position, numericality: { greater_than_or_equal_to: 0 }
end
