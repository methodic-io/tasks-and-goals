# encoding: utf-8
# frozen_string_literal: true

require 'active_support/concern'

# The methods shared among all models that can be classified based on
# difficulty, importance and urgency.
module Classifiable
  extend ActiveSupport::Concern

  included do
    validates :difficulty, numericality: { only_integer: true }
    validates :difficulty, inclusion:    { in: 0..5 }
    validates :difficulty, exclusion:    { in: [-1, 6] }
    validates :importance, numericality: { only_integer: true }
    validates :importance, inclusion:    { in: 0..3 }
    validates :importance, exclusion:    { in: [-1, 4] }
    validates :urgency,    numericality: { only_integer: true }
    validates :urgency,    inclusion:    { in: 0..3 }
    validates :urgency,    exclusion:    { in: [-1, 4] }
  end
end
