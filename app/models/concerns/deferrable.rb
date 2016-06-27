# encoding: utf-8
# frozen_string_literal: true

require 'active_support/concern'

# The methods shared among all models that can be deferred.
module Deferrable
  extend ActiveSupport::Concern

  included do
    serialize :deferred_at, Array
  end

  def defer(duration = 1.day)
    return self unless due? || overdue?
    deferred_at << Time.current
    self.due_at = duration.from_now
    self
  end

  def deferred?
    deferred_at.any?
  end
end
