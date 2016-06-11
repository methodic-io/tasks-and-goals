# encoding: utf-8
# frozen_string_literal: true

# The ReminderJob class wraps the reminder email feature allowing emails to
# be sent asynchronously via Resque.
class ReminderJob
  @queue = :reminders

  def self.perform(task_id)
    task = Task.find(task_id)
    ReminderMailer.reminder_email(task).deliver_now
  end
end
