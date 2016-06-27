# encoding: utf-8
# frozen_string_literal: true

# The Reminder acts as an interface between the Task and the ReminderJob
# ensuring that only tasks that need reminders receive them.
class Reminder
  def self.setup(task)
    if task.needs_reminding?
      return :this_task_needs_reminding_but_lacks_an_id if task.id.blank?
      return Resque.enqueue_at(task.reminder_at, ReminderJob, task_id: task.id)
    end
    :this_task_does_not_need_a_reminder
  end

  def self.clear(task)
    if task.needs_reminding?
      return Resque.remove_delayed(ReminderJob, task_id: task.id)
    end
    :this_task_does_not_have_a_reminder_to_clear
  end
end
