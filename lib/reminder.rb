# encoding: utf-8
# frozen_string_literal: true

# The Reminder acts as an interface between the Task and the ReminderJob
# ensuring that only tasks that need reminders receive them.
class Reminder
  def self.setup(task)
    unless task.reminder_at.blank? || task.reminder_at.past?
      return Resque.enqueue_at(task.reminder_at, ReminderJob, task.id)
    end
    :this_task_does_not_need_a_reminder
  end
end
