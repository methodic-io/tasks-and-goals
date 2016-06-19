# encoding: utf-8
# frozen_string_literal: true

require 'active_support/concern'

# The methods shared among all models that can have Reminders.
module Remindable
  extend ActiveSupport::Concern

  included do
    after_create :setup_reminder
  end

  def reminder_at=(new_value)
    return if new_value == reminder_at
    clear_reminder
    super(new_value)
    setup_reminder
  end

  def needs_reminding?
    !reminder_at.blank? && reminder_at.future?
  end

  def clear_reminder
    Reminder.clear(self) if needs_reminding? && !id.blank?
  end

  def setup_reminder
    Reminder.setup(self) if needs_reminding? && !id.blank?
  end
end
