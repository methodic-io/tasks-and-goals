# encoding: utf-8
# frozen_string_literal: true

require 'active_support/concern'

# The methods shared among all models whose records shouldn't be permanantly
# removed from the database.
module Deletable
  extend ActiveSupport::Concern

  def delete
    self.deleted_at = Time.current
    self
  end

  def deleted?
    !deleted_at.blank?
  end

  def undelete
    self.deleted_at = nil
    self
  end

  def active?
    !deleted?
  end
end
