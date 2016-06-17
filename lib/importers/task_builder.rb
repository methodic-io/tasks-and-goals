# encoding: utf-8
# frozen_string_literal: true

require_relative './builder'
require_relative './object_factory'

# A utility that takes a hash of properties and builds a Task.
class TaskBuilder < Builder
  def build
    wrangle_data
    @task = ObjectFactory.new(Task).build(@data).instance
    handle_associations('subtasks', 'subtask_positions', by_task)
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

  def assign_associations(subtasks_data)
    subtasks_data.each do |subtask_data|
      subtask_query = {
        label: subtask_data['title'],
        created_at: Time.zone.parse(subtask_data['created_at'])
      }
      subtask = Subtask.where(subtask_query).first
      @task.subtasks << subtask
    end
  end

  def populate_positions(subtask_positions)
    subtask_positions.each_with_index do |source_id, i|
      subtask_data = @all_data['subtasks'].find { |s| s['id'] == source_id }
      next unless subtask_data
      subtask = @task.subtasks.find(&subtask_selector(subtask_data))
      @task.position_subtask(subtask, i) if subtask
    end
  end

  def subtask_selector(subtask_data)
    lambda do |t|
      t.label == subtask_data['title']
    end
  end
end
