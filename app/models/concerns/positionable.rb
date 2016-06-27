# encoding: utf-8
# frozen_string_literal: true

require 'active_support/concern'

# The methods shared among all models that can be positioned.
module Positionable
  extend ActiveSupport::Concern

  included do
    validates :position, numericality: { greater_than_or_equal_to: 0 }
    validates :position, numericality: { only_integer: true }
  end
end
