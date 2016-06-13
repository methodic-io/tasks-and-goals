# encoding: utf-8
# frozen_string_literal: true

require 'active_support/concern'

# The methods shared among all models that can be completed.
module Completable
  extend ActiveSupport::Concern

  def complete
    self.completed_at = Time.current
    self
  end

  def completed?
    !completed_at.blank?
  end
end
