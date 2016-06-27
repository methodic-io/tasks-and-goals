# encoding: utf-8
# frozen_string_literal: true

require 'active_support/concern'

# The methods shared among all models that can be due.
module Schedulable
  extend ActiveSupport::Concern

  def due?
    !due_at.blank? && due_at.future?
  end

  def overdue?
    !due_at.blank? && due_at.past?
  end
end
