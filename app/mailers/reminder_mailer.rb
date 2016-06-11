# encoding: utf-8
# frozen_string_literal: true

# The ReminderMailer handles Task reminder emails.
class ReminderMailer < ApplicationMailer
  def reminder_email(task)
    mail(to: 'ed@methodic.io', subject: "Task & Goals Reminder: #{task.label}")
  end
end
