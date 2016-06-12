# encoding: utf-8
# frozen_string_literal: true

# The Reminder acts as an interface between the Task and the ReminderJob
# ensuring that only tasks that need reminders receive them.
class Reminder
  def self.setup(task)
    if task.needs_reminding?
      return Resque.enqueue_at(task.reminder_at, ReminderJob, task.id)
    end
    :this_task_does_not_need_a_reminder
  end
end
