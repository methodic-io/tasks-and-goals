# encoding: utf-8
# frozen_string_literal: true

require 'active_support/concern'

# The methods shared among all models require helper methods to ensure
# method paramaters are appropriate.
module Ensurable
  extend ActiveSupport::Concern

  protected

  def ensure_arguments_are_the_correct_class(method, correct_class, *objects)
    objects.each do |object|
      unless object.is_a? correct_class
        msg = "#{self.class}##{method} can only accept Subtasks as arguments."
        raise TypeError, msg
      end
    end
  end

  def ensure_objects_are_associated(method, associations, *objects)
    unless (objects.map(&:id) - associations.map(&:id)).empty?
      msg = "#{self.class} must be associated with the given subtask(s) for " \
            "#{method} to work."
      raise ArgumentError, msg
    end
  end

  def ensure_position_is_in_bounds(method, pos, max)
    if pos >= max || pos < -max
      msg = "The position, #{pos}, must be in bounds (positive or negative) " \
            "for #{method} to work. The positions array has a count of #{max}."
      raise ArgumentError, msg
    end
  end
end
