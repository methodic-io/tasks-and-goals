# encoding: utf-8
# frozen_string_literal: true

require_relative './builder'
require_relative './object_factory'

# A utility that takes a hash of properties and builds a Task.
class TaskBuilder < Builder
  def build
    wrangle_data
    @task = ObjectFactory.new(Task).build(@data).instance
    handle_task_associations
    @task.save!
  end

  private

  def by_task
    -> (h) { h['task_id'] == @data['id'] }
  end

  def wrangle_data
    notes     = find('notes', by_task)
    reminders = find('reminders', by_task)

    # Re-map attributes to keys the Task responds to.
    remapped_data = {
      label:       @data['title'],
      due_at:      @data['due_date'],
      note:        (notes.first['content']  if notes.any?),
      reminder_at: (reminders.first['date'] if reminders.any?)
    }
    @data.merge!(remapped_data)
  end

  def handle_task_associations
    associated_subtasks = find('subtasks', by_task)

    if associated_subtasks.any?
      assign_task_to_subtasks(associated_subtasks)
      positions_data = find('subtask_positions', by_task)
      populate_subtask_positions(positions_data.first['values'])
    end
  end

  def assign_task_to_subtasks(subtasks_data)
    subtasks_data.each do |subtask_data|
      subtask_query = {
        label: subtask_data['title'],
        created_at: Time.zone.parse(subtask_data['created_at']) }
      subtask = Subtask.where(subtask_query).first
      subtask.task = @task
      subtask.save!
    end
  end

  def populate_subtask_positions(subtask_positions)
    subtask_positions.each do |source_id|
      subtask_data = @all_data['subtasks'].find { |s| s['id'] == source_id }
      next unless subtask_data
      subtask = @task.subtasks.where(label: subtask_data['title']).first
      @task.subtask_positions << subtask.id if subtask
    end
  end
end
